import 'package:frontend/models/gender.dart';
import 'package:frontend/models/species.dart';

class Dinosaur {
  int id;
  String name;
  Species species;
  int age;
  double weight;
  Gender gender;

  Dinosaur(
      this.id, this.name, this.species, this.age, this.weight, this.gender);
}
