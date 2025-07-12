part of 'letter_bloc.dart';

abstract class LetterEvent extends Equatable {
  const LetterEvent();

  @override
  List<Object?> get props => [];
}

// Template Events
class LoadTemplates extends LetterEvent {
  final String? category;
  final String? search;

  const LoadTemplates({this.category, this.search});

  @override
  List<Object?> get props => [category, search];
}

class LoadTemplate extends LetterEvent {
  final int templateId;

  const LoadTemplate(this.templateId);

  @override
  List<Object?> get props => [templateId];
}

class LoadCategories extends LetterEvent {
  const LoadCategories();
}

class SelectTemplate extends LetterEvent {
  final LetterTemplateModel template;

  const SelectTemplate(this.template);

  @override
  List<Object?> get props => [template];
}

class ClearTemplateSelection extends LetterEvent {
  const ClearTemplateSelection();
}

// Letter Generation Events
class GenerateLetter extends LetterEvent {
  final int templateId;
  final String clientName;
  final String? clientEmail;
  final String? clientPhone;
  final Map<String, dynamic> clientMatters;
  final bool generateAsync;

  const GenerateLetter({
    required this.templateId,
    required this.clientName,
    this.clientEmail,
    this.clientPhone,
    required this.clientMatters,
    this.generateAsync = true,
  });

  @override
  List<Object?> get props => [
    templateId,
    clientName,
    clientEmail,
    clientPhone,
    clientMatters,
    generateAsync,
  ];
}

class CheckLetterStatus extends LetterEvent {
  final String requestId;

  const CheckLetterStatus(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class UpdateClientMatters extends LetterEvent {
  final String fieldName;
  final dynamic value;

  const UpdateClientMatters({required this.fieldName, required this.value});

  @override
  List<Object?> get props => [fieldName, value];
}

class ClearClientMatters extends LetterEvent {
  const ClearClientMatters();
}

class ValidateForm extends LetterEvent {
  final LetterTemplateModel template;
  final Map<String, dynamic> clientMatters;

  const ValidateForm({required this.template, required this.clientMatters});

  @override
  List<Object?> get props => [template, clientMatters];
}

// History Events
class LoadLetterHistory extends LetterEvent {
  final int page;
  final int perPage;

  const LoadLetterHistory({this.page = 1, this.perPage = 15});

  @override
  List<Object?> get props => [page, perPage];
}

// Reset Events
class ResetLetterState extends LetterEvent {
  const ResetLetterState();
}

class ClearLetterError extends LetterEvent {
  const ClearLetterError();
}

// Update Letter Event
class UpdateLetter extends LetterEvent {
  final String requestId;
  final String generatedLetter;
  final String? clientName;
  final String? clientEmail;
  final String? clientPhone;

  const UpdateLetter({
    required this.requestId,
    required this.generatedLetter,
    this.clientName,
    this.clientEmail,
    this.clientPhone,
  });

  @override
  List<Object?> get props => [
    requestId,
    generatedLetter,
    clientName,
    clientEmail,
    clientPhone,
  ];
}
