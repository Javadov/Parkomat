class Person {
  int? id;
  String name;
  String personalNumber;

  Person({
    this.id,
    required this.name,
    required this.personalNumber,
  });

  @override
  String toString() {
    return 'ID: $id, Namn: $name, Personnummer: $personalNumber';
  }
}