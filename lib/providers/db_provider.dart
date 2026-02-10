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
        await db.execute('PRAGMA foreign_keys = ON');

        await db.execute('''
          CREATE TABLE tracks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            updated_at INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE participants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            track_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            avatar TEXT NOT NULL,
            FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future<int> insertTrack(Track track) async {
    final db = await database;
    return await db.insert('tracks', track.toMap());
  }

  Future<int> insertTrackWithParticipants({
    required String trackName,
    required List<Map<String,String>> participants,
  }) async {
    final db = await database;

    return await db.transaction<int>((txn) async {
      final trackId = await txn.insert(
        'tracks',
        {
          'name': trackName,
          'created_at': DateTime.now().millisecondsSinceEpoch,
        },
      );

      for (var item in participants) {
        await txn.insert(
          'participants',
          {
            'track_id': trackId,
            'name': item['name'],
            'avatar': item['avatar']
          },
        );
      }

      return trackId;
    });
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
