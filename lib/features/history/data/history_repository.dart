import 'dart:io';
import 'package:vnedownloader/features/download/domain/download_item.dart';
import 'database_helper.dart';

abstract class HistoryRepository {
  Future<List<DownloadItem>> getAll();
  Future<DownloadItem?> getById(String id);
  Future<void> save(DownloadItem item);
  Future<void> update(DownloadItem item);
  Future<void> delete(String id, {bool deleteFile = false});
  Future<void> clearAll({bool deleteFiles = false});
}

class SqliteHistoryRepository implements HistoryRepository {
  final DatabaseHelper _dbHelper;

  SqliteHistoryRepository([DatabaseHelper? dbHelper])
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  @override
  Future<List<DownloadItem>> getAll() async {
    return await _dbHelper.getAllItems();
  }

  @override
  Future<DownloadItem?> getById(String id) async {
    return await _dbHelper.getItemById(id);
  }

  @override
  Future<void> save(DownloadItem item) async {
    await _dbHelper.insertItem(item);
  }

  @override
  Future<void> update(DownloadItem item) async {
    await _dbHelper.updateItem(item);
  }

  @override
  Future<void> delete(String id, {bool deleteFile = false}) async {
    if (deleteFile) {
      final item = await _dbHelper.getItemById(id);
      if (item?.fileUri != null) {
        try {
          final file = File(item!.fileUri!);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (_) {}
      }
    }
    await _dbHelper.deleteItem(id);
  }

  @override
  Future<void> clearAll({bool deleteFiles = false}) async {
    if (deleteFiles) {
      final items = await _dbHelper.getAllItems();
      for (final item in items) {
        if (item.fileUri != null) {
          try {
            final file = File(item.fileUri!);
            if (await file.exists()) {
              await file.delete();
            }
          } catch (_) {}
        }
      }
    }
    await _dbHelper.clearAll();
  }
}
