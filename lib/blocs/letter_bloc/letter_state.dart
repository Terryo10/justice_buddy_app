part of 'letter_bloc.dart';

abstract class LetterState extends Equatable {
  const LetterState();

  @override
  List<Object?> get props => [];
}

class LetterInitial extends LetterState {}

class LetterLoading extends LetterState {}

// Template States
class TemplatesLoaded extends LetterState {
  final List<LetterTemplateModel> templates;
  final Map<String, String>? categories;
  final LetterTemplateModel? selectedTemplate;
  final String? currentCategory;
  final String? searchQuery;

  const TemplatesLoaded({
    required this.templates,
    this.categories,
    this.selectedTemplate,
    this.currentCategory,
    this.searchQuery,
  });

  TemplatesLoaded copyWith({
    List<LetterTemplateModel>? templates,
    Map<String, String>? categories,
    LetterTemplateModel? selectedTemplate,
    String? currentCategory,
    String? searchQuery,
  }) {
    return TemplatesLoaded(
      templates: templates ?? this.templates,
      categories: categories ?? this.categories,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      currentCategory: currentCategory ?? this.currentCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    templates,
    categories,
    selectedTemplate,
    currentCategory,
    searchQuery,
  ];
}

class TemplateDetailsLoaded extends LetterState {
  final LetterTemplateModel template;

  const TemplateDetailsLoaded({required this.template});

  @override
  List<Object?> get props => [template];
}

class CategoriesLoaded extends LetterState {
  final Map<String, String> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

// Form States
class LetterFormState extends LetterState {
  final LetterTemplateModel template;
  final Map<String, dynamic> clientMatters;
  final String clientName;
  final String? clientEmail;
  final String? clientPhone;
  final List<String> validationErrors;
  final bool isValid;

  const LetterFormState({
    required this.template,
    required this.clientMatters,
    required this.clientName,
    this.clientEmail,
    this.clientPhone,
    required this.validationErrors,
    required this.isValid,
  });

  LetterFormState copyWith({
    LetterTemplateModel? template,
    Map<String, dynamic>? clientMatters,
    String? clientName,
    String? clientEmail,
    String? clientPhone,
    List<String>? validationErrors,
    bool? isValid,
  }) {
    return LetterFormState(
      template: template ?? this.template,
      clientMatters: clientMatters ?? this.clientMatters,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      clientPhone: clientPhone ?? this.clientPhone,
      validationErrors: validationErrors ?? this.validationErrors,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
    template,
    clientMatters,
    clientName,
    clientEmail,
    clientPhone,
    validationErrors,
    isValid,
  ];
}

// Generation States
class LetterGenerating extends LetterState {
  final LetterRequestModel request;

  const LetterGenerating({required this.request});

  @override
  List<Object?> get props => [request];
}

class LetterGenerated extends LetterState {
  final LetterRequestModel request;

  const LetterGenerated({required this.request});

  @override
  List<Object?> get props => [request];
}

class LetterStatusUpdated extends LetterState {
  final LetterRequestModel request;

  const LetterStatusUpdated({required this.request});

  @override
  List<Object?> get props => [request];
}

class LetterUpdated extends LetterState {
  final LetterRequestModel request;

  const LetterUpdated({required this.request});

  @override
  List<Object?> get props => [request];
}

// History States
class HistoryLoaded extends LetterState {
  final List<LetterRequestModel> history;
  final int currentPage;
  final bool hasMore;

  const HistoryLoaded({
    required this.history,
    required this.currentPage,
    required this.hasMore,
  });

  HistoryLoaded copyWith({
    List<LetterRequestModel>? history,
    int? currentPage,
    bool? hasMore,
  }) {
    return HistoryLoaded(
      history: history ?? this.history,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [history, currentPage, hasMore];
}

// Error State
class LetterError extends LetterState {
  final String message;

  const LetterError({required this.message});

  @override
  List<Object?> get props => [message];
}
