import 'package:parkomat/models/parking_space.dart';
import 'package:parkomat/database/database.dart';
import 'package:sqlite3/sqlite3.dart';

class ParkingSpaceRepository {
  static final ParkingSpaceRepository _instance = ParkingSpaceRepository._internal();
  final Database db;

  factory ParkingSpaceRepository() {
    return _instance;
  }

  ParkingSpaceRepository._internal() : db = DatabaseHelper().db;

  void add(ParkingSpace space) {
    final stmt = db.prepare(
      'INSERT INTO parking_spaces (id, address, price_per_hour) VALUES (?, ?, ?);'
    );
    stmt.execute([space.id, space.address, space.pricePerHour]);
    stmt.dispose();
  }

  List<ParkingSpace> getAll() {
    final ResultSet result = db.select('SELECT * FROM parking_spaces;');
    return result.map((row) {
      return ParkingSpace(
        id: row['id'] as String,
        address: row['address'] as String,
        pricePerHour: row['price_per_hour'] as double,
      );
    }).toList();
  }

  ParkingSpace? getById(String id) {
    final stmt = db.prepare(
      'SELECT * FROM parking_spaces WHERE id = ?;'
    );
    final ResultSet result = stmt.select([id]);
    stmt.dispose();

    if (result.isNotEmpty) {
      final row = result.first;
      return ParkingSpace(
        id: row['id'] as String,
        address: row['address'] as String,
        pricePerHour: row['price_per_hour'] as double,
      );
    } else {
      return null;
    }
  }

  void update(ParkingSpace updatedSpace) {
    final stmt = db.prepare(
      'UPDATE parking_spaces SET address = ?, price_per_hour = ? WHERE id = ?;'
    );
    stmt.execute([
      updatedSpace.address,
      updatedSpace.pricePerHour,
      updatedSpace.id
    ]);
    stmt.dispose();
  }

  void delete(String id) {
    final stmt = db.prepare(
      'DELETE FROM parking_spaces WHERE id = ?;'
    );
    stmt.execute([id]);
    stmt.dispose();
  }
}