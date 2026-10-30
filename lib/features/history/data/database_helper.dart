import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vnedownloader/features/download/domain/download_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'vnedownloader.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE downloads (
            id TEXT PRIMARY KEY,
            sourceId TEXT NOT NULL,
            url TEXT NOT NULL,
            title TEXT NOT NULL,
            thumbnailUrl TEXT,
            quality TEXT NOT NULL,
            format TEXT NOT NULL,
            sizeBytes INTEGER,
            status TEXT NOT NULL,
            progress REAL NOT NULL,
            fileUri TEXT,
            errorCode TEXT,
            createdAt TEXT NOT NULL,
            completedAt TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertItem(DownloadItem item) async {
    final db = await database;
    return await db.insert(
      'downloads',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateItem(DownloadItem item) async {
    final db = await database;
    return await db.update(
      'downloads',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(String id) async {
    final db = await database;
    return await db.delete(
      'downloads',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearAll() async {
    final db = await database;
    return await db.delete('downloads');
  }

  Future<List<DownloadItem>> getAllItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'downloads',
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => DownloadItem.fromMap(map)).toList();
  }

  Future<DownloadItem?> getItemById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'downloads',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return DownloadItem.fromMap(maps.first);
    }
    return null;
  }
}
