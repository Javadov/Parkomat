import 'package:parkomat/models/person.dart';
import 'package:parkomat/database/database.dart';
import 'package:sqlite3/sqlite3.dart';

class PersonRepository {
  static final PersonRepository _instance = PersonRepository._internal();
  final Database db;

  factory PersonRepository() {
    return _instance;
  }

  PersonRepository._internal() : db = DatabaseHelper().db;

  void add(Person person) {
    final stmt = db.prepare(
      'INSERT INTO persons (name, personal_number) VALUES (?, ?);'
    );
    stmt.execute([person.name, person.personalNumber]);
    stmt.dispose();
  }

  List<Person> getAll() {
    final ResultSet result = db.select('SELECT * FROM persons;');
    return result.map((row) {
      return Person(
        id: row['id'] as int,
        name: row['name'] as String,
        personalNumber: row['personal_number'] as String,
      );
    }).toList();
  }

  Person? getByPersonalNumber(String personalNumber) {
    final stmt = db.prepare(
      'SELECT * FROM persons WHERE personal_number = ?;'
    );
    final ResultSet result = stmt.select([personalNumber]);
    stmt.dispose();

    if (result.isNotEmpty) {
      final row = result.first;
      return Person(
        id: row['id'] as int,
        name: row['name'] as String,
        personalNumber: row['personal_number'] as String,
      );
    } else {
      return null;
    }
  }

  Person? getById(int id) {
    final stmt = db.prepare(
      'SELECT * FROM persons WHERE id = ?;'
    );
    final ResultSet result = stmt.select([id]);
    stmt.dispose();

    if (result.isNotEmpty) {
      final row = result.first;
      return Person(
        id: row['id'] as int,
        name: row['name'] as String,
        personalNumber: row['personal_number'] as String,
      );
    } else {
      return null;
    }
  }

  void update(Person updatedPerson) {
    final stmt = db.prepare(
      'UPDATE persons SET name = ?, personal_number = ? WHERE personal_number = ?;'
    );
    stmt.execute([
      updatedPerson.name,
      updatedPerson.personalNumber,
      updatedPerson.personalNumber
    ]);
    stmt.dispose();
  }

  void delete(String personalNumber) {
    final stmt = db.prepare(
      'DELETE FROM persons WHERE personal_number = ?;'
    );
    stmt.execute([personalNumber]);
    stmt.dispose();
  }
}