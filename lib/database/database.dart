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
    // Ange sökvägen till databasen
    final dbPath = _getDatabasePath('parkomat.db');
    db = sqlite3.open(dbPath);
    _createTables();
  }

  String _getDatabasePath(String dbName) {
    final directory = Directory.current.path;
    return p.join(directory, dbName);
  }

  void _createTables() {
    // Skapa tabeller om de inte redan finns
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
      CREATE TABLE IF NOT EXISTS parking_areas (
        id TEXT PRIMARY KEY,
        address TEXT NOT NULL,
        price_per_hour REAL NOT NULL
      );
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS parkings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicle_id INTEGER NOT NULL,
        parking_areas_id TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        FOREIGN KEY(vehicle_id) REFERENCES vehicles(id),
        FOREIGN KEY(parking_areas_id) REFERENCES parking_areas(id)
      );
    ''');
  }

  void close() {
    db.dispose();
  }
}