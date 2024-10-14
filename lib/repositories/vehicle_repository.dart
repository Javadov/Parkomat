import 'package:parkomat/models/person.dart';
import 'package:parkomat/models/vehicle.dart';
import 'package:parkomat/database/database.dart';
import 'package:parkomat/repositories/person_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class VehicleRepository {
  static final VehicleRepository _instance = VehicleRepository._internal();
  final Database db;
  final PersonRepository personRepo = PersonRepository(); // För att hämta ägare

  factory VehicleRepository() {
    return _instance;
  }

  VehicleRepository._internal() : db = DatabaseHelper().db;

  void add(Vehicle vehicle) {
    final stmt = db.prepare(
      'INSERT INTO vehicles (registration_number, type, owner_id) VALUES (?, ?, ?);'
    );
    stmt.execute([
      vehicle.registrationNumber,
      vehicle.type.toString().split('.').last,
      vehicle.owner.id
    ]);
    stmt.dispose();
  }

  List<Vehicle> getAll() {
    final ResultSet result = db.select('SELECT * FROM vehicles;');
    return result.map((row) {
      final owner = personRepo.getById(row['owner_id'] as int);
      return Vehicle(
        id: row['id'] as int,
        registrationNumber: row['registration_number'] as String,
        type: VehicleType.values.firstWhere(
          (e) => e.toString().split('.').last == row['type'],
          orElse: () => VehicleType.other,
        ),
        owner: owner!,
      );
    }).toList();
  }

  Vehicle? getByRegistrationNumber(String registrationNumber) {
    final stmt = db.prepare(
      'SELECT * FROM vehicles WHERE registration_number = ?;'
    );
    final ResultSet result = stmt.select([registrationNumber]);
    stmt.dispose();

    if (result.isNotEmpty) {
      final row = result.first;
      final owner = personRepo.getById(row['owner_id'] as int);
      return Vehicle(
        id: row['id'] as int,
        registrationNumber: row['registration_number'] as String,
        type: VehicleType.values.firstWhere(
          (e) => e.toString().split('.').last == row['type'],
          orElse: () => VehicleType.other,
        ),
        owner: owner!,
      );
    } else {
      return null;
    }
  }

    Vehicle? getById(int id) {
    final stmt = db.prepare(
      'SELECT * FROM persons WHERE id = ?;'
    );
    final ResultSet result = stmt.select([id]);
    stmt.dispose();

    if (result.isNotEmpty) {
      final row = result.first;
      return Vehicle(
        id: row['id'] as int,
        registrationNumber: row['registration_number'] as String,
        type: row['type'] as VehicleType,
        owner: row['owner_id'] as Person,
      );
    } else {
      return null;
    }
  }

  void update(Vehicle updatedVehicle) {
    final stmt = db.prepare(
      'UPDATE vehicles SET registration_number = ?, type = ?, owner_id = ? WHERE registration_number = ?;'
    );
    stmt.execute([
      updatedVehicle.registrationNumber,
      updatedVehicle.type.toString().split('.').last,
      updatedVehicle.owner.id,
      updatedVehicle.registrationNumber
    ]);
    stmt.dispose();
  }

  void delete(String registrationNumber) {
    final stmt = db.prepare(
      'DELETE FROM vehicles WHERE registration_number = ?;'
    );
    stmt.execute([registrationNumber]);
    stmt.dispose();
  }
}