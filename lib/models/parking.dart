import 'vehicle.dart';
import 'parking_space.dart';

class Parking {
  int? id;
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  DateTime startTime;
  DateTime? endTime;

  Parking({
    this.id,
    required this.vehicle,
    required this.parkingSpace,
    required this.startTime,
    this.endTime,
  });

  @override
  String toString() {
    String end = endTime != null ? endTime.toString() : 'Pågående';
    return 'ID: $id, Fordon: ${vehicle.registrationNumber}, Parkeringsplats: ${parkingSpace.id}, Starttid: $startTime, Sluttid: $end';
  }
}