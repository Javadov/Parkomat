import 'package:parkomat/models/parking.dart';
import 'package:parkomat/database/database.dart';
import 'package:parkomat/repositories/parking_area_repository.dart';
import 'package:parkomat/repositories/vehicle_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class ParkingRepository {
  static final ParkingRepository _instance = ParkingRepository._internal();
  final Database db;
  final VehicleRepository vehicleRepo = VehicleRepository();
  final ParkingAreaRepository spaceRepo = ParkingAreaRepository();

  factory ParkingRepository() {
    return _instance;
  }

  ParkingRepository._internal() : db = DatabaseHelper().db;

  void add(Parking parking) {
    final stmt = db.prepare(
      'INSERT INTO parkings (vehicle_id, parking_space_id, start_time, end_time) VALUES (?, ?, ?, ?);'
    );
    stmt.execute([
      parking.vehicle.id,
      parking.parkingSpace.id,
      parking.startTime.toIso8601String(),
      parking.endTime?.toIso8601String()
    ]);
    stmt.dispose();
  }

  List<Parking> getAll() {
    final ResultSet result = db.select('SELECT * FROM parkings;');
    return result.map((row) {
      final vehicle = vehicleRepo.getById(row['vehicle_id'] as int);
      final space = spaceRepo.getById(row['parking_space_id'] as String);
      return Parking(
        id: row['id'] as int,
        vehicle: vehicle!,
        parkingSpace: space!,
        startTime: DateTime.parse(row['start_time'] as String),
        endTime: row['end_time'] != null ? DateTime.parse(row['end_time'] as String) : null,
      );
    }).toList();
  }

  Parking? getById(int id) {
    final stmt = db.prepare(
      'SELECT * FROM parkings WHERE id = ?;'
    );
    final ResultSet result = stmt.select([id]);
    stmt.dispose();

    if (result.isNotEmpty) {
      final row = result.first;
      final vehicle = vehicleRepo.getById(row['vehicle_id'] as int);
      final space = spaceRepo.getById(row['parking_space_id'] as String);
      return Parking(
        id: row['id'] as int,
        vehicle: vehicle!,
        parkingSpace: space!,
        startTime: DateTime.parse(row['start_time'] as String),
        endTime: row['end_time'] != null ? DateTime.parse(row['end_time'] as String) : null,
      );
    } else {
      return null;
    }
  }

  void update(Parking updatedParking) {
    final stmt = db.prepare(
      'UPDATE parkings SET vehicle_id = ?, parking_space_id = ?, start_time = ?, end_time = ? WHERE id = ?;'
    );
    stmt.execute([
      updatedParking.vehicle.id,
      updatedParking.parkingSpace.id,
      updatedParking.startTime.toIso8601String(),
      updatedParking.endTime?.toIso8601String(),
      updatedParking.id
    ]);
    stmt.dispose();
  }

  void delete(int id) {
    final stmt = db.prepare(
      'DELETE FROM parkings WHERE id = ?;'
    );
    stmt.execute([id]);
    stmt.dispose();
  }
}