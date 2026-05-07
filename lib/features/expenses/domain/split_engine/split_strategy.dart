class ParticipantShare {
  final String userId;
  final int shareAmountPaise;
  final double? sharePercentage;

  const ParticipantShare({required this.userId, required this.shareAmountPaise, this.sharePercentage});
}

abstract class SplitStrategy {
  List<ParticipantShare> calculate({
    required int totalAmountPaise,
    required List<String> participantIds,
    Map<String, dynamic>? metadata,
  });
}
