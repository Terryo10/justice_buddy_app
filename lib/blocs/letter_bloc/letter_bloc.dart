import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/letter_template_model.dart';
import '../../models/letter_request_model.dart';
import '../../repositories/letter_repository/letter_repository.dart';

part 'letter_event.dart';
part 'letter_state.dart';

class LetterBloc extends Bloc<LetterEvent, LetterState> {
  final LetterRepository letterRepository;

  LetterBloc({required this.letterRepository})
    : super(const LetterDataState()) {
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
    emit(
      LetterLoading(
        previousState:
            state is LetterDataState ? state as LetterDataState : null,
      ),
    );
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

      final currentState =
          state is LetterDataState
              ? state as LetterDataState
              : const LetterDataState();
      emit(
        currentState.copyWith(
          templates: templates,
          categories: categories ?? currentState.categories,
          currentCategory: event.category,
          searchQuery: event.search,
          templatesLoaded: true,
        ),
      );
    } catch (error) {
      emit(
        LetterError(
          message: error.toString(),
          previousState:
              state is LetterDataState ? state as LetterDataState : null,
        ),
      );
    }
  }

  Future<void> _onLoadTemplate(
    LoadTemplate event,
    Emitter<LetterState> emit,
  ) async {
    emit(
      LetterLoading(
        previousState:
            state is LetterDataState ? state as LetterDataState : null,
      ),
    );
    try {
      final template = await letterRepository.getTemplate(event.templateId);
      final currentState =
          state is LetterDataState
              ? state as LetterDataState
              : const LetterDataState();
      emit(currentState.copyWith(selectedTemplate: template));
    } catch (error) {
      emit(
        LetterError(
          message: error.toString(),
          previousState:
              state is LetterDataState ? state as LetterDataState : null,
        ),
      );
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<LetterState> emit,
  ) async {
    emit(
      LetterLoading(
        previousState:
            state is LetterDataState ? state as LetterDataState : null,
      ),
    );
    try {
      final categories = await letterRepository.getCategories();
      final currentState =
          state is LetterDataState
              ? state as LetterDataState
              : const LetterDataState();
      emit(currentState.copyWith(categories: categories));
    } catch (error) {
      emit(
        LetterError(
          message: error.toString(),
          previousState:
              state is LetterDataState ? state as LetterDataState : null,
        ),
      );
    }
  }

  void _onSelectTemplate(SelectTemplate event, Emitter<LetterState> emit) {
    final currentState =
        state is LetterDataState
            ? state as LetterDataState
            : const LetterDataState();
    emit(
      currentState.copyWith(
        selectedTemplate: event.template,
        // Reset form data when selecting a new template
        clearClientData: true,
        validationErrors:
            event.template.requiredFields
                .map((field) => "Required field '$field' is missing or empty")
                .toList(),
        isFormValid: false,
      ),
    );
  }

  void _onClearTemplateSelection(
    ClearTemplateSelection event,
    Emitter<LetterState> emit,
  ) {
    final currentState =
        state is LetterDataState
            ? state as LetterDataState
            : const LetterDataState();
    emit(currentState.copyWith(clearSelectedTemplate: true));
  }

  Future<void> _onGenerateLetter(
    GenerateLetter event,
    Emitter<LetterState> emit,
  ) async {
    try {
      final currentState =
          state is LetterDataState
              ? state as LetterDataState
              : const LetterDataState();
      emit(currentState.copyWith(isGenerating: true));

      final request = await letterRepository.generateLetter(
        templateId: event.templateId,
        clientName: event.clientName,
        clientEmail: event.clientEmail,
        clientPhone: event.clientPhone,
        clientMatters: event.clientMatters,
        generateAsync: event.generateAsync,
      );

      emit(
        currentState.copyWith(
          currentLetter: request,
          isGenerating: false,
          clientName: event.clientName,
          clientEmail: event.clientEmail,
          clientPhone: event.clientPhone,
          clientMatters: event.clientMatters,
        ),
      );
    } catch (error) {
      emit(
        LetterError(
          message: error.toString(),
          previousState:
              state is LetterDataState ? state as LetterDataState : null,
        ),
      );
    }
  }

  Future<void> _onCheckLetterStatus(
    CheckLetterStatus event,
    Emitter<LetterState> emit,
  ) async {
    emit(
      LetterLoading(
        previousState:
            state is LetterDataState ? state as LetterDataState : null,
      ),
    );
    try {
      final request = await letterRepository.checkLetterStatus(event.requestId);
      final currentState =
          state is LetterDataState
              ? state as LetterDataState
              : const LetterDataState();

      if (request.isFailed) {
        emit(
          LetterError(
            message: request.errorMessage ?? 'Letter generation failed',
            previousState: currentState,
          ),
        );
      } else {
        emit(
          currentState.copyWith(
            currentLetter: request,
            isGenerating: !request.isCompleted,
          ),
        );
      }
    } catch (error) {
      emit(
        LetterError(
          message: error.toString(),
          previousState:
              state is LetterDataState ? state as LetterDataState : null,
        ),
      );
    }
  }

  void _onUpdateClientMatters(
    UpdateClientMatters event,
    Emitter<LetterState> emit,
  ) {
    final currentState =
        state is LetterDataState
            ? state as LetterDataState
            : const LetterDataState();

    if (currentState.selectedTemplate != null) {
      final updatedMatters = Map<String, dynamic>.from(
        currentState.clientMatters,
      );
      updatedMatters[event.fieldName] = event.value;

      // Validate the form with updated matters
      final validationErrors = letterRepository.validateTemplateFields(
        currentState.selectedTemplate!,
        updatedMatters,
      );

      emit(
        currentState.copyWith(
          clientMatters: updatedMatters,
          validationErrors: validationErrors,
          isFormValid: validationErrors.isEmpty,
        ),
      );
    }
  }

  void _onClearClientMatters(
    ClearClientMatters event,
    Emitter<LetterState> emit,
  ) {
    final currentState =
        state is LetterDataState
            ? state as LetterDataState
            : const LetterDataState();

    if (currentState.selectedTemplate != null) {
      emit(
        currentState.copyWith(
          clearClientData: true,
          validationErrors:
              currentState.selectedTemplate!.requiredFields
                  .map((field) => "Required field '$field' is missing or empty")
                  .toList(),
          isFormValid: false,
        ),
      );
    }
  }

  void _onValidateForm(ValidateForm event, Emitter<LetterState> emit) {
    final validationErrors = letterRepository.validateTemplateFields(
      event.template,
      event.clientMatters,
    );

    final currentState =
        state is LetterDataState
            ? state as LetterDataState
            : const LetterDataState();
    emit(
      currentState.copyWith(
        selectedTemplate: event.template,
        clientMatters: event.clientMatters,
        validationErrors: validationErrors,
        isFormValid: validationErrors.isEmpty,
      ),
    );
  }

  Future<void> _onLoadLetterHistory(
    LoadLetterHistory event,
    Emitter<LetterState> emit,
  ) async {
    emit(
      LetterLoading(
        previousState:
            state is LetterDataState ? state as LetterDataState : null,
      ),
    );
    try {
      final history = await letterRepository.getLetterHistory(
        page: event.page,
        perPage: event.perPage,
      );

      final currentState =
          state is LetterDataState
              ? state as LetterDataState
              : const LetterDataState();
      emit(
        currentState.copyWith(
          history: history,
          currentPage: event.page,
          hasMore: history.length == event.perPage,
          historyLoaded: true,
        ),
      );
    } catch (error) {
      emit(
        LetterError(
          message: error.toString(),
          previousState:
              state is LetterDataState ? state as LetterDataState : null,
        ),
      );
    }
  }

  void _onResetLetterState(ResetLetterState event, Emitter<LetterState> emit) {
    emit(const LetterDataState());
  }

  Future<void> _onUpdateLetter(
    UpdateLetter event,
    Emitter<LetterState> emit,
  ) async {
    try {
      final currentState =
          state is LetterDataState
              ? state as LetterDataState
              : const LetterDataState();
      emit(currentState.copyWith(isUpdating: true));

      final updatedRequest = await letterRepository.updateLetter(
        requestId: event.requestId,
        generatedLetter: event.generatedLetter,
        clientName: event.clientName,
        clientEmail: event.clientEmail,
        clientPhone: event.clientPhone,
      );

      emit(
        currentState.copyWith(currentLetter: updatedRequest, isUpdating: false),
      );
    } catch (error) {
      emit(
        LetterError(
          message: error.toString(),
          previousState:
              state is LetterDataState ? state as LetterDataState : null,
        ),
      );
    }
  }

  void _onClearLetterError(ClearLetterError event, Emitter<LetterState> emit) {
    emit(const LetterDataState());
  }
}
