import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vnedownloader/features/download/domain/download_item.dart';
import '../data/history_repository.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return SqliteHistoryRepository();
});

class HistoryNotifier extends StateNotifier<List<DownloadItem>> {
  final HistoryRepository _repo;

  HistoryNotifier(this._repo) : super([]) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final items = await _repo.getAll();
    state = items;
  }

  Future<void> saveOrUpdate(DownloadItem item) async {
    await _repo.save(item);
    await loadHistory();
  }

  Future<void> updateItem(DownloadItem item) async {
    await _repo.update(item);
    await loadHistory();
  }

  Future<void> deleteItem(String id, {bool deleteFile = false}) async {
    await _repo.delete(id, deleteFile: deleteFile);
    await loadHistory();
  }

  Future<void> clearAll({bool deleteFiles = false}) async {
    await _repo.clearAll(deleteFiles: deleteFiles);
    await loadHistory();
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<DownloadItem>>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repo);
});
