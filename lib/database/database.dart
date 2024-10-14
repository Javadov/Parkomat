import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  late Database db;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal() {
    final dbPath = _getDatabasePath('parkomat.db');
    db = sqlite3.open(dbPath);
    _createTables();
  }

  String _getDatabasePath(String dbName) {
    final directory = Directory.current.path;
    return p.join(directory, dbName);
  }

  void _createTables() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS persons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        personal_number TEXT UNIQUE NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        registration_number TEXT UNIQUE NOT NULL,
        type TEXT NOT NULL,
        owner_id INTEGER NOT NULL,
        FOREIGN KEY(owner_id) REFERENCES persons(id)
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS parking_spaces (
        id TEXT PRIMARY KEY,
        address TEXT NOT NULL,
        price_per_hour REAL NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS parkings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicle_id INTEGER NOT NULL,
        parking_space_id TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        FOREIGN KEY(vehicle_id) REFERENCES vehicles(id),
        FOREIGN KEY(parking_space_id) REFERENCES parking_spaces(id)
      );
    ''');
  }

  void close() {
    db.dispose();
  }
}