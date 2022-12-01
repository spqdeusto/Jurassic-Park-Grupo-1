import 'dart:convert';
import 'package:frontend/helpers/urls.dart';
import 'package:frontend/models/alarm.dart';
import 'package:frontend/models/enclosure.dart';
import 'package:frontend/models/truck.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:frontend/models/dinosaur.dart';

import '../models/gender.dart';
import '../models/species.dart';

Future<List<Species>> getSpecies() async {
  Client client = http.Client();

  List<Species> speciesList = [];

  List response = json.decode((await client.get(allSpecies())).body);

  for (var species in response) {
    int id = int.parse(species['id']);
    String name = species['name'];
    bool dangerousness = species['dangerousness'];

    speciesList.add(Species(id, name, dangerousness));
  }
  return speciesList;
}

Future<List<Gender>> getGenders() async {
  Client client = http.Client();

  List<Gender> genders = [];

  List response = json.decode((await client.get(allGenders())).body);

  for (var gender in response) {
    int id = int.parse(gender['id']);
    String name = gender['name'];

    genders.add(Gender(id, name));
  }
  return genders;
}

Future<List<Alarm>> getAlarms() async {
  Client client = http.Client();

  List<Alarm> alarms = [];

  List response = json.decode((await client.get(allAlarms())).body);

  for (var alarm in response) {
    int id = int.parse(alarm['id']);
    String name = alarm['name'];
    bool active = alarm['active'];

    alarms.add(Alarm(id, name, active));
  }
  return alarms;
}

Future<List<Dinosaur>> getDinosaurs(
    List<Species> speciesList, List<Gender> gendersList) async {
  Client client = http.Client();

  List<Dinosaur> dinosaurs = [];

  List response = json.decode((await client.get(allDinosaurs())).body);

  for (var dinosaur in response) {
    int id = int.parse(dinosaur['id']);
    String name = dinosaur['name'];
    //Los id empiezan desde 1, pero las posiciones de una lista desde 0. Por eso, para asignar una especie se resta 1 al id, para obtener su posición en la lista
    Species species = speciesList[dinosaur['species'] - 1];
    int age = dinosaur['age'];
    double weight = dinosaur['weight'];
    //Los id empiezan desde 1, pero las posiciones de una lista desde 0. Por eso, para asignar un género se resta 1 al id, para obtener su posición en la lista
    Gender gender = gendersList[dinosaur['gender'] - 1];

    dinosaurs.add(Dinosaur(
      id,
      name,
      species,
      age,
      weight,
      gender,
    ));
  }
  return dinosaurs;
}

Future<List<Enclosure>> getEnclosures(List<Species> speciesList) async {
  Client client = http.Client();

  List<Enclosure> enclosures = [];

  List response = json.decode((await client.get(allEnclosures())).body);

  for (var enclosure in response) {
    int id = int.parse(enclosure['id']);
    String name = enclosure['name'];
    //Los id empiezan desde 1, pero las posiciones de una lista desde 0. Por eso, para asignar una especie se resta 1 al id, para obtener su posición en la lista
    Species species = speciesList[enclosure['species'] - 1];
    bool electricity = enclosure['electricity'];

    enclosures.add(Enclosure(id, name, species, electricity));
  }
  return enclosures;
}

Future<List<Truck>> getTrucks() async {
  Client client = http.Client();

  List<Truck> trucks = [];

  List response = json.decode((await client.get(allTrucks())).body);

  for (var truck in response) {
    int id = int.parse(truck['id']);
    bool onRute = truck['onRute'];
    int passengers = truck['passengers'];
    bool securitySystem = truck['securitySystem'];

    trucks.add(Truck(id, onRute, passengers, securitySystem));
  }
  return trucks;
}

Future<bool> createDinosaur(Dinosaur dinosaur) async {
  Client client = http.Client();
  var bodyEncoded = jsonEncode({
    "name": dinosaur.name,
    "species": dinosaur.species.id.toString(),
    "age": dinosaur.age,
    "weight": dinosaur.weight,
    "gender": dinosaur.gender.id.toString(),
  });

  var response = await client.post(createDinosaurUri(),
      headers: {"Content-Type": "application/json"}, body: bodyEncoded);

  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> updateDinosaur(Dinosaur dinosaur) async {
  Client client = http.Client();
  var bodyEncoded = jsonEncode({
    "name": dinosaur.name,
    "species": dinosaur.species.id.toString(),
    "age": dinosaur.age,
    "weight": dinosaur.weight,
    "gender": dinosaur.gender.id.toString(),
  });

  var response = await client.put(updateDinosaurUri(dinosaur.id.toString()),
      headers: {"Content-Type": "application/json"}, body: bodyEncoded);

  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> deleteDinosaur(int id) async {
  Client client = http.Client();

  var response = await client.get(deleteDinosaurUri(id.toString()),
      headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    return true;
  }
  return false;
}
