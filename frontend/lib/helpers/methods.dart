import 'dart:convert';
import 'package:frontend/helpers/urls.dart';
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
    int id = species['id'];
    String name = species['name'];
    bool dangerousness = species['dangerousness'];

    speciesList.add(Species(id, name, dangerousness));
  }
  return speciesList;
}

Future<List<Gender>> getGenders() async {
  Client client = http.Client();

  List<Gender> gendersList = [];

  List response = json.decode((await client.get(allGenders())).body);

  for (var gender in response) {
    int id = gender['id'];
    String name = gender['name'];

    gendersList.add(Gender(id, name));
  }
  return gendersList;
}

Future<List<Dinosaur>> getDinosaurs(
    List<Species> speciesList, List<Gender> gendersList) async {
  Client client = http.Client();

  List<Dinosaur> dinosaurs = [];

  List response = json.decode((await client.get(allDinosaurs())).body);

  for (var dinosaur in response) {
    int id = dinosaur['id'];
    String name = dinosaur['name'];
    Species species = speciesList[dinosaur['species'] - 1];
    int age = dinosaur['age'];
    double weight = dinosaur['weight'];
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
