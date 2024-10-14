class ParkingArea {
  String id;
  String address;
  double pricePerHour;

  ParkingArea({
    required this.id,
    required this.address,
    required this.pricePerHour,
  });

  @override
  String toString() {
    return 'ID: $id, Adress: $address, Pris per timme: \$${pricePerHour.toStringAsFixed(2)}';
  }
}