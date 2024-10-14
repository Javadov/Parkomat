import 'vehicle.dart';
import 'parking_area.dart';

class Parking {
  int? id; // Primärnyckel, nullable eftersom det är auto-increment
  Vehicle vehicle;
  ParkingArea parkingArea;
  DateTime startTime;
  DateTime? endTime;

  Parking({
    this.id,
    required this.vehicle,
    required this.parkingArea,
    required this.startTime,
    this.endTime,
  });

  @override
  String toString() {
    String end = endTime != null ? endTime.toString() : 'Pågående';
    return 'ID: $id, Fordon: ${vehicle.registrationNumber}, Parkeringsplats: ${parkingArea.id}, Starttid: $startTime, Sluttid: $end';
  }
}