part of 'letter_bloc.dart';

abstract class LetterState extends Equatable {
  const LetterState();

  @override
  List<Object?> get props => [];
}

class LetterInitial extends LetterState {}

class LetterLoading extends LetterState {
  final String? loadingMessage;
  final LetterDataState? previousState;

  const LetterLoading({this.loadingMessage, this.previousState});

  @override
  List<Object?> get props => [loadingMessage, previousState];
}

// Main comprehensive state that holds all data
class LetterDataState extends LetterState {
  // Templates data
  final List<LetterTemplateModel> templates;
  final Map<String, String>? categories;
  final LetterTemplateModel? selectedTemplate;
  final String? currentCategory;
  final String? searchQuery;
  final bool templatesLoaded;

  // History data
  final List<LetterRequestModel> history;
  final int currentPage;
  final bool hasMore;
  final bool historyLoaded;

  // Current letter data
  final LetterRequestModel? currentLetter;
  final bool isGenerating;
  final bool isUpdating;

  // Form data
  final Map<String, dynamic> clientMatters;
  final String clientName;
  final String? clientEmail;
  final String? clientPhone;
  final List<String> validationErrors;
  final bool isFormValid;

  const LetterDataState({
    // Templates
    this.templates = const [],
    this.categories,
    this.selectedTemplate,
    this.currentCategory,
    this.searchQuery,
    this.templatesLoaded = false,

    // History
    this.history = const [],
    this.currentPage = 1,
    this.hasMore = false,
    this.historyLoaded = false,

    // Current letter
    this.currentLetter,
    this.isGenerating = false,
    this.isUpdating = false,

    // Form
    this.clientMatters = const {},
    this.clientName = '',
    this.clientEmail,
    this.clientPhone,
    this.validationErrors = const [],
    this.isFormValid = false,
  });

  LetterDataState copyWith({
    // Templates
    List<LetterTemplateModel>? templates,
    Map<String, String>? categories,
    LetterTemplateModel? selectedTemplate,
    String? currentCategory,
    String? searchQuery,
    bool? templatesLoaded,

    // History
    List<LetterRequestModel>? history,
    int? currentPage,
    bool? hasMore,
    bool? historyLoaded,

    // Current letter
    LetterRequestModel? currentLetter,
    bool? isGenerating,
    bool? isUpdating,

    // Form
    Map<String, dynamic>? clientMatters,
    String? clientName,
    String? clientEmail,
    String? clientPhone,
    List<String>? validationErrors,
    bool? isFormValid,

    // Special flags for clearing values
    bool clearSelectedTemplate = false,
    bool clearCurrentLetter = false,
    bool clearClientData = false,
  }) {
    return LetterDataState(
      // Templates
      templates: templates ?? this.templates,
      categories: categories ?? this.categories,
      selectedTemplate: clearSelectedTemplate ? null : (selectedTemplate ?? this.selectedTemplate),
      currentCategory: currentCategory ?? this.currentCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      templatesLoaded: templatesLoaded ?? this.templatesLoaded,

      // History
      history: history ?? this.history,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      historyLoaded: historyLoaded ?? this.historyLoaded,

      // Current letter
      currentLetter: clearCurrentLetter ? null : (currentLetter ?? this.currentLetter),
      isGenerating: isGenerating ?? this.isGenerating,
      isUpdating: isUpdating ?? this.isUpdating,

      // Form
      clientMatters: clearClientData ? const {} : (clientMatters ?? this.clientMatters),
      clientName: clearClientData ? '' : (clientName ?? this.clientName),
      clientEmail: clearClientData ? null : (clientEmail ?? this.clientEmail),
      clientPhone: clearClientData ? null : (clientPhone ?? this.clientPhone),
      validationErrors: validationErrors ?? this.validationErrors,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
    templates,
    categories,
    selectedTemplate,
    currentCategory,
    searchQuery,
    templatesLoaded,
    history,
    currentPage,
    hasMore,
    historyLoaded,
    currentLetter,
    isGenerating,
    isUpdating,
    clientMatters,
    clientName,
    clientEmail,
    clientPhone,
    validationErrors,
    isFormValid,
  ];
}

// Error State
class LetterError extends LetterState {
  final String message;
  final LetterDataState? previousState;

  const LetterError({required this.message, this.previousState});

  @override
  List<Object?> get props => [message, previousState];
}

// Backward compatibility states (deprecated but kept for migration)
@deprecated
class TemplatesLoaded extends LetterDataState {
  const TemplatesLoaded({
    required List<LetterTemplateModel> templates,
    Map<String, String>? categories,
    LetterTemplateModel? selectedTemplate,
    String? currentCategory,
    String? searchQuery,
  }) : super(
    templates: templates,
    categories: categories,
    selectedTemplate: selectedTemplate,
    currentCategory: currentCategory,
    searchQuery: searchQuery,
    templatesLoaded: true,
  );
}

@deprecated
class TemplateDetailsLoaded extends LetterDataState {
  const TemplateDetailsLoaded({required LetterTemplateModel template})
      : super(selectedTemplate: template);
}

@deprecated
class LetterFormState extends LetterDataState {
  const LetterFormState({
    required LetterTemplateModel template,
    required Map<String, dynamic> clientMatters,
    required String clientName,
    String? clientEmail,
    String? clientPhone,
    required List<String> validationErrors,
    required bool isValid,
  }) : super(
    selectedTemplate: template,
    clientMatters: clientMatters,
    clientName: clientName,
    clientEmail: clientEmail,
    clientPhone: clientPhone,
    validationErrors: validationErrors,
    isFormValid: isValid,
  );
}

@deprecated
class LetterGenerating extends LetterDataState {
  const LetterGenerating({required LetterRequestModel request})
      : super(currentLetter: request, isGenerating: true);
}

@deprecated
class LetterGenerated extends LetterDataState {
  const LetterGenerated({required LetterRequestModel request})
      : super(currentLetter: request, isGenerating: false);
}

@deprecated
class LetterStatusUpdated extends LetterDataState {
  const LetterStatusUpdated({required LetterRequestModel request})
      : super(currentLetter: request);
}

@deprecated
class LetterUpdated extends LetterDataState {
  const LetterUpdated({required LetterRequestModel request})
      : super(currentLetter: request, isUpdating: false);
}

@deprecated
class HistoryLoaded extends LetterDataState {
  const HistoryLoaded({
    required List<LetterRequestModel> history,
    required int currentPage,
    required bool hasMore,
  }) : super(
    history: history,
    currentPage: currentPage,
    hasMore: hasMore,
    historyLoaded: true,
  );
}

@deprecated
class CategoriesLoaded extends LetterDataState {
  const CategoriesLoaded({required Map<String, String> categories})
      : super(categories: categories);
}
