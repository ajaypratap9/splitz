import 'split_strategy.dart';

class EqualSplitStrategy implements SplitStrategy {
  @override
  List<ParticipantShare> calculate({
    required int totalAmountPaise,
    required List<String> participantIds,
    Map<String, dynamic>? metadata,
  }) {
    if (participantIds.isEmpty) return [];
    if (participantIds.length == 1) {
      return [ParticipantShare(userId: participantIds.first, shareAmountPaise: totalAmountPaise)];
    }

    final count = participantIds.length;
    final baseShare = totalAmountPaise ~/ count;
    final remainder = totalAmountPaise % count;

    return participantIds.asMap().entries.map((entry) {
      final extra = entry.key < remainder ? 1 : 0;
      return ParticipantShare(
        userId: entry.value,
        shareAmountPaise: baseShare + extra,
        sharePercentage: (100.0 / count),
      );
    }).toList();
  }
}

class UnequalSplitStrategy implements SplitStrategy {
  @override
  List<ParticipantShare> calculate({required int totalAmountPaise, required List<String> participantIds, Map<String, dynamic>? metadata}) {
    final amounts = metadata?['amounts'] as Map<String, int>? ?? {};
    return participantIds.map((id) => ParticipantShare(userId: id, shareAmountPaise: amounts[id] ?? 0)).toList();
  }
}

class PercentageSplitStrategy implements SplitStrategy {
  @override
  List<ParticipantShare> calculate({required int totalAmountPaise, required List<String> participantIds, Map<String, dynamic>? metadata}) {
    final percentages = metadata?['percentages'] as Map<String, double>? ?? {};
    return participantIds.map((id) {
      final pct = percentages[id] ?? 0;
      return ParticipantShare(userId: id, shareAmountPaise: (totalAmountPaise * pct / 100).round(), sharePercentage: pct);
    }).toList();
  }
}

class ExactAmountSplitStrategy implements SplitStrategy {
  @override
  List<ParticipantShare> calculate({required int totalAmountPaise, required List<String> participantIds, Map<String, dynamic>? metadata}) {
    final amounts = metadata?['amounts'] as Map<String, int>? ?? {};
    return participantIds.map((id) => ParticipantShare(userId: id, shareAmountPaise: amounts[id] ?? 0)).toList();
  }
}
