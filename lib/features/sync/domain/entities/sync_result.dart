sealed class SyncResult {
  const SyncResult();
}


class SyncUpToDate extends SyncResult {
  const SyncUpToDate();
}


class SyncUpdated extends SyncResult {
  const SyncUpdated({
    required this.categories,
    required this.questions,
    required this.questionsAdded,
  });

  final int categories;
  final int questions;
  final int questionsAdded;
}


class SyncFailed extends SyncResult {
  const SyncFailed(this.message);

  final String message;
}