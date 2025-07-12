import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/letter_template_model.dart';
import '../../models/letter_request_model.dart';
import '../../repositories/letter_repository/letter_repository.dart';

part 'letter_event.dart';
part 'letter_state.dart';

class LetterBloc extends Bloc<LetterEvent, LetterState> {
  final LetterRepository letterRepository;

  LetterBloc({required this.letterRepository}) : super(LetterInitial()) {
    on<LoadTemplates>(_onLoadTemplates);
    on<LoadTemplate>(_onLoadTemplate);
    on<LoadCategories>(_onLoadCategories);
    on<SelectTemplate>(_onSelectTemplate);
    on<ClearTemplateSelection>(_onClearTemplateSelection);
    on<GenerateLetter>(_onGenerateLetter);
    on<CheckLetterStatus>(_onCheckLetterStatus);
    on<UpdateClientMatters>(_onUpdateClientMatters);
    on<ClearClientMatters>(_onClearClientMatters);
    on<ValidateForm>(_onValidateForm);
    on<LoadLetterHistory>(_onLoadLetterHistory);
    on<UpdateLetter>(_onUpdateLetter);
    on<ResetLetterState>(_onResetLetterState);
    on<ClearLetterError>(_onClearLetterError);
  }

  Future<void> _onLoadTemplates(
    LoadTemplates event,
    Emitter<LetterState> emit,
  ) async {
    emit(LetterLoading());
    try {
      final templates = await letterRepository.getTemplates(
        category: event.category,
        search: event.search,
      );

      // If this is the first load, also load categories
      Map<String, String>? categories;
      if (event.category == null && event.search == null) {
        try {
          categories = await letterRepository.getCategories();
        } catch (e) {
          // Categories loading failed, but templates loaded successfully
          // Continue with templates only
        }
      }

      emit(
        TemplatesLoaded(
          templates: templates,
          categories: categories,
          currentCategory: event.category,
          searchQuery: event.search,
        ),
      );
    } catch (error) {
      emit(LetterError(message: error.toString()));
    }
  }

  Future<void> _onLoadTemplate(
    LoadTemplate event,
    Emitter<LetterState> emit,
  ) async {
    emit(LetterLoading());
    try {
      final template = await letterRepository.getTemplate(event.templateId);
      emit(TemplateDetailsLoaded(template: template));
    } catch (error) {
      emit(LetterError(message: error.toString()));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<LetterState> emit,
  ) async {
    emit(LetterLoading());
    try {
      final categories = await letterRepository.getCategories();
      emit(CategoriesLoaded(categories: categories));
    } catch (error) {
      emit(LetterError(message: error.toString()));
    }
  }

  void _onSelectTemplate(SelectTemplate event, Emitter<LetterState> emit) {
    if (state is TemplatesLoaded) {
      final currentState = state as TemplatesLoaded;
      emit(currentState.copyWith(selectedTemplate: event.template));
    } else {
      // Create a new form state for the selected template
      emit(
        LetterFormState(
          template: event.template,
          clientMatters: {},
          clientName: '',
          validationErrors: [],
          isValid: false,
        ),
      );
    }
  }

  void _onClearTemplateSelection(
    ClearTemplateSelection event,
    Emitter<LetterState> emit,
  ) {
    if (state is TemplatesLoaded) {
      final currentState = state as TemplatesLoaded;
      emit(currentState.copyWith(selectedTemplate: null));
    }
  }

  Future<void> _onGenerateLetter(
    GenerateLetter event,
    Emitter<LetterState> emit,
  ) async {
    try {
      final request = await letterRepository.generateLetter(
        templateId: event.templateId,
        clientName: event.clientName,
        clientEmail: event.clientEmail,
        clientPhone: event.clientPhone,
        clientMatters: event.clientMatters,
        generateAsync: event.generateAsync,
      );

      if (request.isCompleted) {
        emit(LetterGenerated(request: request));
      } else {
        emit(LetterGenerating(request: request));
      }
    } catch (error) {
      emit(LetterError(message: error.toString()));
    }
  }

  Future<void> _onCheckLetterStatus(
    CheckLetterStatus event,
    Emitter<LetterState> emit,
  ) async {
    try {
      final request = await letterRepository.checkLetterStatus(event.requestId);

      if (request.isCompleted) {
        emit(LetterGenerated(request: request));
      } else if (request.isFailed) {
        emit(
          LetterError(
            message: request.errorMessage ?? 'Letter generation failed',
          ),
        );
      } else {
        emit(LetterStatusUpdated(request: request));
      }
    } catch (error) {
      emit(LetterError(message: error.toString()));
    }
  }

  void _onUpdateClientMatters(
    UpdateClientMatters event,
    Emitter<LetterState> emit,
  ) {
    if (state is LetterFormState) {
      final currentState = state as LetterFormState;
      final updatedMatters = Map<String, dynamic>.from(
        currentState.clientMatters,
      );
      updatedMatters[event.fieldName] = event.value;

      // Validate the form with updated matters
      final validationErrors = letterRepository.validateTemplateFields(
        currentState.template,
        updatedMatters,
      );

      emit(
        currentState.copyWith(
          clientMatters: updatedMatters,
          validationErrors: validationErrors,
          isValid: validationErrors.isEmpty,
        ),
      );
    }
  }

  void _onClearClientMatters(
    ClearClientMatters event,
    Emitter<LetterState> emit,
  ) {
    if (state is LetterFormState) {
      final currentState = state as LetterFormState;
      emit(
        currentState.copyWith(
          clientMatters: {},
          clientName: '',
          clientEmail: null,
          clientPhone: null,
          validationErrors:
              currentState.template.requiredFields
                  .map((field) => "Required field '$field' is missing or empty")
                  .toList(),
          isValid: false,
        ),
      );
    }
  }

  void _onValidateForm(ValidateForm event, Emitter<LetterState> emit) {
    final validationErrors = letterRepository.validateTemplateFields(
      event.template,
      event.clientMatters,
    );

    if (state is LetterFormState) {
      final currentState = state as LetterFormState;
      emit(
        currentState.copyWith(
          validationErrors: validationErrors,
          isValid: validationErrors.isEmpty,
        ),
      );
    } else {
      emit(
        LetterFormState(
          template: event.template,
          clientMatters: event.clientMatters,
          clientName: '',
          validationErrors: validationErrors,
          isValid: validationErrors.isEmpty,
        ),
      );
    }
  }

  Future<void> _onLoadLetterHistory(
    LoadLetterHistory event,
    Emitter<LetterState> emit,
  ) async {
    emit(LetterLoading());
    try {
      final history = await letterRepository.getLetterHistory(
        page: event.page,
        perPage: event.perPage,
      );

      emit(
        HistoryLoaded(
          history: history,
          currentPage: event.page,
          hasMore: history.length == event.perPage,
        ),
      );
    } catch (error) {
      emit(LetterError(message: error.toString()));
    }
  }

  void _onResetLetterState(ResetLetterState event, Emitter<LetterState> emit) {
    emit(LetterInitial());
  }

  Future<void> _onUpdateLetter(
    UpdateLetter event,
    Emitter<LetterState> emit,
  ) async {
    try {
      emit(LetterLoading());
      
      final updatedRequest = await letterRepository.updateLetter(
        requestId: event.requestId,
        generatedLetter: event.generatedLetter,
        clientName: event.clientName,
        clientEmail: event.clientEmail,
        clientPhone: event.clientPhone,
      );

      emit(LetterUpdated(request: updatedRequest));
    } catch (error) {
      emit(LetterError(message: error.toString()));
    }
  }

  void _onClearLetterError(ClearLetterError event, Emitter<LetterState> emit) {
    emit(LetterInitial());
  }
}
