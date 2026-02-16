import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:split_track/models/expense.dart';
import 'package:split_track/models/expense_paid_by.dart';
import 'package:split_track/models/participant.dart';
import 'package:split_track/models/split.dart' as split_model;
import 'package:split_track/models/track.dart';
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
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      }
    );
  }

  Future<int> insertTrack(Track track) async {
    final db = await database;
    return await db.insert('tracks', track.toMap());
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<int> insertExpensePaidBy(ExpensePaidBy expensePaidBy) async {
    final db = await database;
    return await db.insert('expense_paid_by', expensePaidBy.toMap());
  }

  Future<int> insertSplit(split_model.Split split) async {
    final db = await database;
    return await db.insert('splits', split.toMap());
  }

  Future<void> insertFullExpense({
    required Expense expense,
    required ExpensePaidBy paidBy,
    required List<split_model.Split> splits,
  }) async {
    final db = await database;

    await db.transaction((txn) async {
      final expenseId = await txn.insert(
        'expenses',
        expense.toMap(),
      );

      await txn.insert(
        'expense_paid_by',
        paidBy.copyWith(expenseId: expenseId).toMap(),
      );

      for (final split in splits) {
        await txn.insert(
          'splits',
          split.copyWith(expenseId: expenseId).toMap(),
        );
      }

    });
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

  Future<List<Expense>> getAllExpenses(int trackId) async {
    final db = await database;
    final List<Map<String, dynamic>>result =  await db.query(
      'expenses',
      where: 'track_id = ?',
      whereArgs: [trackId],
      orderBy: 'created_at DESC'
    );
    return result.map((e) => Expense.fromMap(e)).toList();
  }

  Future<List<Participant>> getAllParticipants(int trackId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'participants',
      orderBy: 'name DESC',
      where: 'track_id = ?',
      whereArgs: [trackId]
    );

    return result.map((e) => Participant.fromMap(e)).toList();
  }

  Future<void> _onCreate(Database db, int version) async {
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

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        track_id INTEGER NOT NULL,
        description TEXT NOT NULL,
        total_amount REAL NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE expense_paid_by (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expense_id INTEGER NOT NULL,
        participant_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        FOREIGN KEY (expense_id) REFERENCES expenses(id) ON DELETE CASCADE,
        FOREIGN KEY (participant_id) REFERENCES participants(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE splits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        expense_id INTEGER NOT NULL,
        participant_id INTEGER NOT NULL,
        percentage REAL NOT NULL,
        amount REAL NOT NULL,
        FOREIGN KEY (expense_id) REFERENCES expenses(id) ON DELETE CASCADE,
        FOREIGN KEY (participant_id) REFERENCES participants(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    await db.execute('PRAGMA foreign_keys = ON');

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS expenses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          track_id INTEGER NOT NULL,
          description TEXT NOT NULL,
          total_amount REAL NOT NULL,
          created_at INTEGER NOT NULL,
          FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS expense_paid_by (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          expense_id INTEGER NOT NULL,
          participant_id INTEGER NOT NULL,
          amount REAL NOT NULL,
          FOREIGN KEY (expense_id) REFERENCES expenses(id) ON DELETE CASCADE,
          FOREIGN KEY (participant_id) REFERENCES participants(id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS splits (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          expense_id INTEGER NOT NULL,
          participant_id INTEGER NOT NULL,
          percentage REAL NOT NULL,
          amount REAL NOT NULL,
          FOREIGN KEY (expense_id) REFERENCES expenses(id) ON DELETE CASCADE,
          FOREIGN KEY (participant_id) REFERENCES participants(id) ON DELETE CASCADE
        )
      ''');
    }
  }
}
