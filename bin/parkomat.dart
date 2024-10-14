import 'dart:io';
import 'package:parkomat/models/person.dart';
import 'package:parkomat/models/vehicle.dart';
import 'package:parkomat/models/parking_space.dart';
import 'package:parkomat/models/parking.dart';
import 'package:parkomat/repositories/person_repository.dart';
import 'package:parkomat/repositories/vehicle_repository.dart';
import 'package:parkomat/repositories/parking_space_repository.dart';
import 'package:parkomat/repositories/parking_repository.dart';

void main() {
  final personRepo = PersonRepository();
  final vehicleRepo = VehicleRepository();
  final spaceRepo = ParkingSpaceRepository();
  final parkingRepo = ParkingRepository();

  while (true) {
    printMainMenu();
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        handlePersons(personRepo);
        break;
      case '2':
        handleVehicles(vehicleRepo, personRepo);
        break;
      case '3':
        handleParkingSpaces(spaceRepo);
        break;
      case '4':
        handleParkings(parkingRepo, vehicleRepo, spaceRepo);
        break;
      case '5':
        print('Avslutar programmet. Hej då!');
        exit(0);
      default:
        print('Ogiltigt val. Försök igen.');
    }
  }
}

// Huvudmeny
void printMainMenu() {
  print('\nVälkommen till Parkeringsappen!');
  print('Vad vill du hantera?');
  print('1. Personer');
  print('2. Fordon');
  print('3. Parkeringsplatser');
  print('4. Parkeringar');
  print('5. Avsluta');
  stdout.write('Välj ett alternativ (1-5): ');
}

// Hantera Personer
void handlePersons(PersonRepository repo) {
  while (true) {
    print('\nDu har valt att hantera Personer. Vad vill du göra?');
    print('1. Skapa ny person');
    print('2. Visa alla personer');
    print('3. Uppdatera person');
    print('4. Ta bort person');
    print('5. Gå tillbaka till huvudmenyn');
    stdout.write('Välj ett alternativ (1-5): ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        createPerson(repo);
        break;
      case '2':
        listPersons(repo);
        break;
      case '3':
        updatePerson(repo);
        break;
      case '4':
        deletePerson(repo);
        break;
      case '5':
        return;
      default:
        print('Ogiltigt val. Försök igen.');
    }
  }
}

// Skapa ny Person
void createPerson(PersonRepository repo) {
  stdout.write('Ange namn: ');
  String? name = stdin.readLineSync();

  stdout.write('Ange personnummer: ');
  String? personalNumber = stdin.readLineSync();

  if (name != null && personalNumber != null && name.isNotEmpty && personalNumber.isNotEmpty) {
    // Kontrollera om personnumret redan finns
    Person? existing = repo.getByPersonalNumber(personalNumber);
    if (existing != null) {
      print('En person med detta personnummer finns redan.');
      return;
    }

    Person person = Person(name: name, personalNumber: personalNumber);
    repo.add(person);
    print('Person tillagd: $person');
  } else {
    print('Ogiltig inmatning. Försök igen.');
  }
}

// Visa alla Personer
void listPersons(PersonRepository repo) {
  List<Person> persons = repo.getAll();
  if (persons.isEmpty) {
    print('Inga personer registrerade.');
  } else {
    print('\nRegistrerade Personer:');
    for (var person in persons) {
      print(person);
    }
  }
}

// Uppdatera Person
void updatePerson(PersonRepository repo) {
  stdout.write('Ange personnummer för personen du vill uppdatera: ');
  String? personalNumber = stdin.readLineSync();

  if (personalNumber != null && personalNumber.isNotEmpty) {
    Person? person = repo.getByPersonalNumber(personalNumber);
    if (person != null) {
      stdout.write('Ange nytt namn (nuvarande: ${person.name}): ');
      String? newName = stdin.readLineSync();

      if (newName != null && newName.isNotEmpty) {
        person.name = newName;
        repo.update(person);
        print('Person uppdaterad: $person');
      } else {
        print('Ogiltig inmatning. Uppdatering avbruten.');
      }
    } else {
      print('Person inte hittad.');
    }
  } else {
    print('Ogiltig inmatning.');
  }
}

// Ta bort Person
void deletePerson(PersonRepository repo) {
  stdout.write('Ange personnummer för personen du vill ta bort: ');
  String? personalNumber = stdin.readLineSync();

  if (personalNumber != null && personalNumber.isNotEmpty) {
    Person? person = repo.getByPersonalNumber(personalNumber);
    if (person != null) {
      repo.delete(personalNumber);
      print('Person borttagen: $person');
    } else {
      print('Person inte hittad.');
    }
  } else {
    print('Ogiltig inmatning.');
  }
}

// Hantera Fordon
void handleVehicles(VehicleRepository repo, PersonRepository personRepo) {
  while (true) {
    print('\nDu har valt att hantera Fordon. Vad vill du göra?');
    print('1. Skapa nytt fordon');
    print('2. Visa alla fordon');
    print('3. Uppdatera fordon');
    print('4. Ta bort fordon');
    print('5. Gå tillbaka till huvudmenyn');
    stdout.write('Välj ett alternativ (1-5): ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        createVehicle(repo, personRepo);
        break;
      case '2':
        listVehicles(repo);
        break;
      case '3':
        updateVehicle(repo, personRepo);
        break;
      case '4':
        deleteVehicle(repo);
        break;
      case '5':
        return;
      default:
        print('Ogiltigt val. Försök igen.');
    }
  }
}

// Skapa nytt Fordon
void createVehicle(VehicleRepository repo, PersonRepository personRepo) {
  stdout.write('Ange registreringsnummer: ');
  String? registrationNumber = stdin.readLineSync();

  print('Välj typ av fordon:');
  print('1. Bil');
  print('2. Motorcykel');
  print('3. Lastbil');
  print('4. Annat');
  stdout.write('Välj ett alternativ (1-4): ');
  String? typeChoice = stdin.readLineSync();

  VehicleType? type;
  switch (typeChoice) {
    case '1':
      type = VehicleType.car;
      break;
    case '2':
      type = VehicleType.motorcycle;
      break;
    case '3':
      type = VehicleType.truck;
      break;
    case '4':
      type = VehicleType.other;
      break;
    default:
      print('Ogiltigt val. Fordonet kommer att klassificeras som "Annat".');
      type = VehicleType.other;
  }

  stdout.write('Ange ägarens personnummer: ');
  String? ownerPersonalNumber = stdin.readLineSync();

  if (registrationNumber != null &&
      ownerPersonalNumber != null &&
      registrationNumber.isNotEmpty &&
      ownerPersonalNumber.isNotEmpty &&
      type != null) {
    // Kontrollera om fordonet redan finns
    Vehicle? existingVehicle = repo.getByRegistrationNumber(registrationNumber);
    if (existingVehicle != null) {
      print('Ett fordon med detta registreringsnummer finns redan.');
      return;
    }

    Person? owner = personRepo.getByPersonalNumber(ownerPersonalNumber);
    if (owner != null) {
      Vehicle vehicle = Vehicle(
        registrationNumber: registrationNumber,
        type: type,
        owner: owner,
      );
      repo.add(vehicle);
      print('Fordon tillagt: $vehicle');
    } else {
      print('Ägare inte hittad. Skapa först ägaren.');
    }
  } else {
    print('Ogiltig inmatning. Försök igen.');
  }
}

// Visa alla Fordon
void listVehicles(VehicleRepository repo) {
  List<Vehicle> vehicles = repo.getAll();
  if (vehicles.isEmpty) {
    print('Inga fordon registrerade.');
  } else {
    print('\nRegistrerade Fordon:');
    for (var vehicle in vehicles) {
      print(vehicle);
    }
  }
}

// Uppdatera Fordon
void updateVehicle(VehicleRepository repo, PersonRepository personRepo) {
  stdout.write('Ange registreringsnummer för fordonet du vill uppdatera: ');
  String? registrationNumber = stdin.readLineSync();

  if (registrationNumber != null && registrationNumber.isNotEmpty) {
    Vehicle? vehicle = repo.getByRegistrationNumber(registrationNumber);
    if (vehicle != null) {
      stdout.write('Ange nytt registreringsnummer (nuvarande: ${vehicle.registrationNumber}): ');
      String? newRegNumber = stdin.readLineSync();

      print('Välj ny typ av fordon (nuvarande: ${vehicle.type.toString().split('.').last}):');
      print('1. Bil');
      print('2. Motorcykel');
      print('3. Lastbil');
      print('4. Annat');
      stdout.write('Välj ett alternativ (1-4): ');
      String? typeChoice = stdin.readLineSync();

      VehicleType? newType;
      switch (typeChoice) {
        case '1':
          newType = VehicleType.car;
          break;
        case '2':
          newType = VehicleType.motorcycle;
          break;
        case '3':
          newType = VehicleType.truck;
          break;
        case '4':
          newType = VehicleType.other;
          break;
        default:
          print('Ogiltigt val. Typen förblir oförändrad.');
          newType = vehicle.type;
      }

      stdout.write('Ange ny ägarens personnummer (nuvarande: ${vehicle.owner.personalNumber}): ');
      String? newOwnerPersonalNumber = stdin.readLineSync();

      Person? newOwner;
      if (newOwnerPersonalNumber != null && newOwnerPersonalNumber.isNotEmpty) {
        newOwner = personRepo.getByPersonalNumber(newOwnerPersonalNumber);
        if (newOwner == null) {
          print('Ny ägare inte hittad. Ägarens ändring avbryts.');
          newOwner = vehicle.owner;
        }
      } else {
        newOwner = vehicle.owner;
      }

      // Kontrollera om nytt registreringsnummer redan finns (om det ändras)
      if (newRegNumber != null && newRegNumber.isNotEmpty && newRegNumber != vehicle.registrationNumber) {
        Vehicle? existingVehicle = repo.getByRegistrationNumber(newRegNumber);
        if (existingVehicle != null) {
          print('Ett fordon med detta nya registreringsnummer finns redan.');
          return;
        }
      }

      // Uppdatera fordonet
      vehicle.registrationNumber = newRegNumber != null && newRegNumber.isNotEmpty ? newRegNumber : vehicle.registrationNumber;
      vehicle.type = newType!;
      vehicle.owner = newOwner!;

      repo.update(vehicle);
      print('Fordon uppdaterat: $vehicle');
    } else {
      print('Fordon inte hittat.');
    }
  } else {
    print('Ogiltig inmatning.');
  }
}

// Ta bort Fordon
void deleteVehicle(VehicleRepository repo) {
  stdout.write('Ange registreringsnummer för fordonet du vill ta bort: ');
  String? registrationNumber = stdin.readLineSync();

  if (registrationNumber != null && registrationNumber.isNotEmpty) {
    Vehicle? vehicle = repo.getByRegistrationNumber(registrationNumber);
    if (vehicle != null) {
      repo.delete(registrationNumber);
      print('Fordon borttaget: $vehicle');
    } else {
      print('Fordon inte hittat.');
    }
  } else {
    print('Ogiltig inmatning.');
  }
}

// Hantera Parkeringsplatser
void handleParkingSpaces(ParkingSpaceRepository repo) {
  while (true) {
    print('\nDu har valt att hantera Parkeringsplatser. Vad vill du göra?');
    print('1. Skapa ny parkeringsplats');
    print('2. Visa alla parkeringsplatser');
    print('3. Uppdatera parkeringsplats');
    print('4. Ta bort parkeringsplats');
    print('5. Gå tillbaka till huvudmenyn');
    stdout.write('Välj ett alternativ (1-5): ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        createParkingSpace(repo);
        break;
      case '2':
        listParkingSpaces(repo);
        break;
      case '3':
        updateParkingSpace(repo);
        break;
      case '4':
        deleteParkingSpace(repo);
        break;
      case '5':
        return;
      default:
        print('Ogiltigt val. Försök igen.');
    }
  }
}

// Skapa ny Parkeringsplats
void createParkingSpace(ParkingSpaceRepository repo) {
  stdout.write('Ange ID för parkeringsplatsen: ');
  String? id = stdin.readLineSync();

  stdout.write('Ange adress: ');
  String? address = stdin.readLineSync();

  stdout.write('Ange pris per timme: ');
  String? priceInput = stdin.readLineSync();
  double? pricePerHour = double.tryParse(priceInput ?? '');

  if (id != null && id.isNotEmpty && address != null && address.isNotEmpty && pricePerHour != null) {
    // Kontrollera om parkeringsplatsen redan finns
    ParkingSpace? existingSpace = repo.getById(id);
    if (existingSpace != null) {
      print('En parkeringsplats med detta ID finns redan.');
      return;
    }

    ParkingSpace space = ParkingSpace(
      id: id,
      address: address,
      pricePerHour: pricePerHour,
    );
    repo.add(space);
    print('Parkeringsplats tillagd: $space');
  } else {
    print('Ogiltig inmatning. Försök igen.');
  }
}

// Visa alla Parkeringsplatser
void listParkingSpaces(ParkingSpaceRepository repo) {
  List<ParkingSpace> spaces = repo.getAll();
  if (spaces.isEmpty) {
    print('Inga parkeringsplatser registrerade.');
  } else {
    print('\nRegistrerade Parkeringsplatser:');
    for (var space in spaces) {
      print(space);
    }
  }
}

// Uppdatera Parkeringsplats
void updateParkingSpace(ParkingSpaceRepository repo) {
  stdout.write('Ange ID för parkeringsplatsen du vill uppdatera: ');
  String? id = stdin.readLineSync();

  if (id != null && id.isNotEmpty) {
    ParkingSpace? space = repo.getById(id);
    if (space != null) {
      stdout.write('Ange ny adress (nuvarande: ${space.address}): ');
      String? newAddress = stdin.readLineSync();

      stdout.write('Ange nytt pris per timme (nuvarande: \$${space.pricePerHour.toStringAsFixed(2)}): ');
      String? newPriceInput = stdin.readLineSync();
      double? newPrice = double.tryParse(newPriceInput ?? '');

      if (newAddress != null && newAddress.isNotEmpty) {
        space.address = newAddress;
      }

      if (newPrice != null) {
        space.pricePerHour = newPrice;
      }

      repo.update(space);
      print('Parkeringsplats uppdaterad: $space');
    } else {
      print('Parkeringsplats inte hittad.');
    }
  } else {
    print('Ogiltig inmatning.');
  }
}

// Ta bort Parkeringsplats
void deleteParkingSpace(ParkingSpaceRepository repo) {
  stdout.write('Ange ID för parkeringsplatsen du vill ta bort: ');
  String? id = stdin.readLineSync();

  if (id != null && id.isNotEmpty) {
    ParkingSpace? space = repo.getById(id);
    if (space != null) {
      repo.delete(id);
      print('Parkeringsplats borttagen: $space');
    } else {
      print('Parkeringsplats inte hittad.');
    }
  } else {
    print('Ogiltig inmatning.');
  }
}

// Hantera Parkeringar
void handleParkings(ParkingRepository repo, VehicleRepository vehicleRepo, ParkingSpaceRepository spaceRepo) {
  while (true) {
    print('\nDu har valt att hantera Parkeringar. Vad vill du göra?');
    print('1. Skapa ny parkering');
    print('2. Visa alla parkeringar');
    print('3. Uppdatera parkering');
    print('4. Ta bort parkering');
    print('5. Gå tillbaka till huvudmenyn');
    stdout.write('Välj ett alternativ (1-5): ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        createParking(repo, vehicleRepo, spaceRepo);
        break;
      case '2':
        listParkings(repo);
        break;
      case '3':
        updateParking(repo);
        break;
      case '4':
        deleteParking(repo);
        break;
      case '5':
        return;
      default:
        print('Ogiltigt val. Försök igen.');
    }
  }
}

// Skapa ny Parkering
void createParking(ParkingRepository repo, VehicleRepository vehicleRepo, ParkingSpaceRepository spaceRepo) {
  stdout.write('Ange registreringsnummer för fordonet: ');
  String? registrationNumber = stdin.readLineSync();

  stdout.write('Ange ID för parkeringsplatsen: ');
  String? spaceId = stdin.readLineSync();

  if (registrationNumber != null && registrationNumber.isNotEmpty && spaceId != null && spaceId.isNotEmpty) {
    Vehicle? vehicle = vehicleRepo.getByRegistrationNumber(registrationNumber);
    ParkingSpace? space = spaceRepo.getById(spaceId);

    if (vehicle != null && space != null) {
      DateTime startTime = DateTime.now();
      Parking parking = Parking(
        vehicle: vehicle,
        parkingSpace: space,
        startTime: startTime,
      );
      repo.add(parking);
      print('Parkering tillagd: $parking');
    } else {
      print('Fordon eller parkeringsplats inte hittad.');
    }
  } else {
    print('Ogiltig inmatning. Försök igen.');
  }
}

// Visa alla Parkeringar
void listParkings(ParkingRepository repo) {
  List<Parking> parkings = repo.getAll();
  if (parkings.isEmpty) {
    print('Inga parkeringar registrerade.');
  } else {
    print('\nRegistrerade Parkeringar:');
    for (var parking in parkings) {
      print(parking);
    }
  }
}

// Uppdatera Parkering
void updateParking(ParkingRepository repo) {
  stdout.write('Ange ID för parkeringen du vill uppdatera: ');
  String? idInput = stdin.readLineSync();
  int? parkingId = int.tryParse(idInput ?? '');

  if (parkingId != null) {
    Parking? parking = repo.getById(parkingId);
    if (parking != null) {
      stdout.write('Ange ny sluttid (YYYY-MM-DD HH:MM) eller lämna tomt för att markera som pågående: ');
      String? endTimeInput = stdin.readLineSync();

      if (endTimeInput != null && endTimeInput.isNotEmpty) {
        try {
          DateTime endTime = DateTime.parse(endTimeInput.replaceFirst(' ', 'T'));
          parking.endTime = endTime;
          repo.update(parking);
          print('Parkering uppdaterad: $parking');
        } catch (e) {
          print('Ogiltigt datumformat. Uppdatering avbruten.');
        }
      } else {
        parking.endTime = null;
        repo.update(parking);
        print('Parkering markerad som pågående: $parking');
      }
    } else {
      print('Parkering inte hittad.');
    }
  } else {
    print('Ogiltig inmatning.');
  }
}

// Ta bort Parkering
void deleteParking(ParkingRepository repo) {
  stdout.write('Ange ID för parkeringen du vill ta bort: ');
  String? idInput = stdin.readLineSync();
  int? parkingId = int.tryParse(idInput ?? '');

  if (parkingId != null) {
    Parking? parking = repo.getById(parkingId);
    if (parking != null) {
      repo.delete(parkingId);
      print('Parkering borttagen: $parking');
    } else {
      print('Parkering inte hittad.');
    }
  } else {
    print('Ogiltig inmatning.');
  }
}