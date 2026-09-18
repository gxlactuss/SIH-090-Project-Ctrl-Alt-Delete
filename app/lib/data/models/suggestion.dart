class Suggestion {
  const Suggestion({
    required this.id,
    required this.spokenPrompt,
    required this.textIfAccepted,
    this.accepted,
  });

  final String id;
  final String spokenPrompt;
  final String textIfAccepted;
  final bool? accepted;

  bool get isAnswered => accepted != null;

  Suggestion copyWith({bool? accepted}) => Suggestion(
    id: id,
    spokenPrompt: spokenPrompt,
    textIfAccepted: textIfAccepted,
    accepted: accepted ?? this.accepted,
  );
}
