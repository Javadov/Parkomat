import 'person.dart';

enum VehicleType { car, motorcycle, truck, other }

class Vehicle {
  int? id;
  String registrationNumber;
  VehicleType type;
  Person owner;

  Vehicle({
    this.id,
    required this.registrationNumber,
    required this.type,
    required this.owner,
  });

  @override
  String toString() {
    return 'ID: $id, Registreringsnummer: $registrationNumber, Typ: ${type.toString().split('.').last}, Ägare: ${owner.name}';
  }
}