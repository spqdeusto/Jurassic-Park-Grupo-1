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

/// Obtiene todas las especies de la base de datos
///
/// Hace una llamada al endpoint gracias a la URI de helpers/urls allSpecies, que nos devuelve una Future List de las especies. Es una Future List debido a que, al ser una llamada a la API, la data no se obtiene de manera inmediata. Por cada elemento de la respuesta, creamos una especie y la añadimos a [species], que es lo que retornamos.

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

/// Obtiene todos los generos de la base de datos
///
/// Hace una llamada al endpoint gracias a la URI de helpers/urls allGenders, que nos devuelve una Future List de los géneros. Es una Future List debido a que, al ser una llamada a la API, la data no se obtiene de manera inmediata. Por cada elemento de la respuesta, creamos un género y la añadimos a [genders], que es lo que retornamos.
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

/// Obtiene todas las alarmas de la base de datos
///
/// Hace una llamada al endpoint gracias a la URI de helpers/urls allAlarms, que nos devuelve una Future List de las alarmas. Es una Future List debido a que, al ser una llamada a la API, la data no se obtiene de manera inmediata. Por cada elemento de la respuesta, creamos una especie y la añadimos a [alarms], que es lo que retornamos.
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

/// Obtiene todos los dinosaurios de la base de datos
///
/// Hace una llamada al endpoint gracias a la URI de helpers/urls allDinosaurs, que nos devuelve una Future List de los dinosaurios. Es una Future List debido a que, al ser una llamada a la API, la data no se obtiene de manera inmediata. Por cada elemento de la respuesta, creamos un dinosaurio y lo añadimos a [dinosaurs], que es lo que retornamos.
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

/// Obtiene todos los recintos de la base de datos
///
/// Hace una llamada al endpoint gracias a la URI de helpers/urls allEnclosures, que nos devuelve una Future List de los recintos. Es una Future List debido a que, al ser una llamada a la API, la data no se obtiene de manera inmediata. Por cada elemento de la respuesta, creamos un recinto y lo añadimos a [enclosures], que es lo que retornamos.
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

/// Obtiene todas las furgonetas de la base de datos
///
/// Hace una llamada al endpoint gracias a la URI de helpers/urls allTrucks, que nos devuelve una Future List de las furgonetas. Es una Future List debido a que, al ser una llamada a la API, la data no se obtiene de manera inmediata. Por cada elemento de la respuesta, creamos una furgoneta y la añadimos a [trucks], que es lo que retornamos.
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

/// Crea un dinosaurio
///
/// Se nos pasa como parametro el dinosaurio a crear [dinosaur]. Sus campos se crean en un body json. Después llamamos al endpoint gracias a la URI createDinosaurUri de helpers/urls. Retorna el ID del dinosaurio creado si la acción se completa correctamente (status code == 200), y 0 en caso contrario (ya que los ids empiezan en 1, no existe el ID 0. Si se retorna este valor, sabremos que se ha producido un error y no realizaremos la acción).
Future<int> createDinosaur(Dinosaur dinosaur) async {
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
    int id = int.parse(json.decode((response).body)['id']);
    return id;
  }
  return 0;
}

///Modifica un dinosaurio
///
///Se pasa como parametro el dinosaurio modificado [dinosaur]. Sus campos se crean en un body json. Después llamamos al endpoint gracias a la URI updateDinosaurUri de helpers/urls, al que le pasamos el id del dinosaurio a modificar. Retorna true si la operación se completa exitosamente (codigo de respuesta == 200) y false en caso contrario.
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

///Elimina un dinosaurio
///
///Se pasa como parametro el id del dinosaurio a eliminar [id]. Llamamos al endpoint gracias a la URI deleteDinosaurUri de helpers/urls, al que le pasamos el id del dinosaurio a eliminar. Retorna true si la operación se completa exitosamente (codigo de respuesta == 200) y false en caso contrario.
Future<bool> deleteDinosaur(int id) async {
  Client client = http.Client();

  var response = await client.get(deleteDinosaurUri(id.toString()),
      headers: {"Content-Type": "application/json"});

  if (response.statusCode == 200) {
    return true;
  }
  return false;
}
