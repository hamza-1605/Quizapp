import 'dart:math';

// Splits [total] questions as evenly as possible between categories.
//
// [available] maps a category id to how many questions it has. No category
// gets more than it has, and the share it cannot fill goes to the others.
Map<int, int> calculateBalancedQuotas({
  required int total,
  required Map<int, int> available,
  required Random random,
}) {
  final quotas = {for (final id in available.keys) id: 0};
  var remaining = total;                                                        // how many cards/questions to be divided
  var active = available.keys.where((id) => available[id]! > 0).toList()        // active is a list of players that need cards
    ..shuffle(random);

  while (remaining > 0 && active.isNotEmpty) {
    final share = remaining ~/ active.length;   // how much each person will get
    final extra = remaining % active.length;    // extra => if there is a remainder

    for (var i = 0; i < active.length; i++) {
      final id = active[i];
      final wanted = share + (i < extra ? 1 : 0);   // determining if they get extra
      final room = available[id]! - quotas[id]!;    // room is how many more questions that category can still give.
      final given = min(wanted, room);              // A category never gives more than it has.
      quotas[id] = quotas[id]! + given;
      remaining -= given;
    }
    active = active.where((id) => quotas[id]! < available[id]!).toList();
  }
  return quotas;
}