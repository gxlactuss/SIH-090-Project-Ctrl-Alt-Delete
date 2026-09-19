class Suggestion {
  const Suggestion({
    required this.id,
    required this.spokenPrompt,
    required this.textIfAccepted,
    this.field,
    this.accepted,
  });

  final String id;
  final String spokenPrompt;
  final String textIfAccepted;

  final String? field;

  final bool? accepted;

  bool get isAnswered => accepted != null;

  Suggestion copyWith({bool? accepted}) => Suggestion(
    id: id,
    spokenPrompt: spokenPrompt,
    textIfAccepted: textIfAccepted,
    field: field,
    accepted: accepted ?? this.accepted,
  );
}
