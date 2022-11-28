import 'package:frontend/models/species.dart';

class Enclosure {
  int id;
  String name;
  Species species;
  bool electricity;

  Enclosure(this.id, this.name, this.species, this.electricity);
}
