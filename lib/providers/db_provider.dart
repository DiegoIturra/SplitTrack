import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:split_track/models/track_model.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  static Database? _database;
  static final DbProvider db = DbProvider._();
  DbProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = p.join(documentsDirectory.path, 'split_track.db');

    debugPrint('DB Path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(''' 
          CREATE TABLE tracks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            participants TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertTrack(Track track) async {
    final db = await database;
    return await db.insert('tracks', track.toMap());
  }

  Future<List<Track>> getAllTracks() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'tracks',
      orderBy: 'created_at DESC',
    );

    return result.map((e) => Track.fromMap(e)).toList();
  }

  Future<int> deleteAllTracks() async {
    final db = await database;
    return await db.delete('tracks');
  }

  Future<int> deleteTrackByName(String name) async {
    final db = await database;
    return await db.delete('tracks', where: 'name = ?', whereArgs: [name]);
  }
}
