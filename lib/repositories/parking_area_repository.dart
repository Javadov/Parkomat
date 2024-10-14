import 'package:parkomat/models/parking_area.dart';
import 'package:parkomat/database/database.dart';
import 'package:sqlite3/sqlite3.dart';

class ParkingAreaRepository {
  static final ParkingAreaRepository _instance = ParkingAreaRepository._internal();
  final Database db;

  factory ParkingAreaRepository() {
    return _instance;
  }

  ParkingAreaRepository._internal() : db = DatabaseHelper().db;

  void add(ParkingArea space) {
    final stmt = db.prepare(
      'INSERT INTO parking_spaces (id, address, price_per_hour) VALUES (?, ?, ?);'
    );
    stmt.execute([space.id, space.address, space.pricePerHour]);
    stmt.dispose();
  }

  List<ParkingArea> getAll() {
    final ResultSet result = db.select('SELECT * FROM parking_spaces;');
    return result.map((row) {
      return ParkingArea(
        id: row['id'] as String,
        address: row['address'] as String,
        pricePerHour: row['price_per_hour'] as double,
      );
    }).toList();
  }

  ParkingArea? getById(String id) {
    final stmt = db.prepare(
      'SELECT * FROM parking_spaces WHERE id = ?;'
    );
    final ResultSet result = stmt.select([id]);
    stmt.dispose();

    if (result.isNotEmpty) {
      final row = result.first;
      return ParkingArea(
        id: row['id'] as String,
        address: row['address'] as String,
        pricePerHour: row['price_per_hour'] as double,
      );
    } else {
      return null;
    }
  }

  void update(ParkingArea updatedSpace) {
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