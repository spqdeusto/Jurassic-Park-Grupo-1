/// Crea la URI al endpoint de get all dinosaurs
///
/// Retorna la URI correspondiente [allDinosaurs]
Uri allDinosaurs() {
  Uri allDinosaurs = Uri.http('127.0.0.1:8000', '/dinosaurs');
  return (allDinosaurs);
}

/// Crea la URI al endpoint de get all species
///
/// Retorna la URI correspondiente [allSpecies]
Uri allSpecies() {
  Uri allSpecies = Uri.http('127.0.0.1:8000', '/species');
  return (allSpecies);
}

/// Crea la URI al endpoint de get all genders
///
/// Retorna la URI correspondiente [allGenders]
Uri allGenders() {
  Uri allGenders = Uri.http('127.0.0.1:8000', '/genders');
  return (allGenders);
}

/// Crea la URI al endpoint de get all alarms
///
/// Retorna la URI correspondiente [allAlarms]
Uri allAlarms() {
  Uri allAlarms = Uri.http('127.0.0.1:8000', '/alarms');
  return (allAlarms);
}

/// Crea la URI al endpoint de get all enclosures
///
/// Retorna la URI correspondiente [allEnclosures]
Uri allEnclosures() {
  Uri allEnclosures = Uri.http('127.0.0.1:8000', '/enclosures');
  return (allEnclosures);
}

/// Crea la URI al endpoint de get all trucks
///
/// Retorna la URI correspondiente [allTrucks]
Uri allTrucks() {
  Uri allTrucks = Uri.http('127.0.0.1:8000', '/trucks');
  return (allTrucks);
}

/// Crea la URI al endpoint de update enclosure
///
/// Retorna la URI correspondiente [updateEnclosure]
Uri updateEnclosure(String id) {
  Uri updateEnclosure = Uri.http('127.0.0.1:8000', '/enclosures/update/$id');
  return (updateEnclosure);
}

/// Crea la URI al endpoint de create dinosaur
///
/// Retorna la URI correspondiente [createDinosaur]
Uri createDinosaurUri() {
  Uri createDinosaur = Uri.http('127.0.0.1:8000', '/dinosaurs');
  return (createDinosaur);
}

/// Crea la URI al endpoint de update dinosaur
///
/// Se pasa por parametro el id del dinosaurio a modificar [id]. Retorna la URI correspondiente [updateDinosaur]
Uri updateDinosaurUri(String id) {
  Uri updateDinosaur = Uri.http('127.0.0.1:8000', '/dinosaurs/update/$id');
  return (updateDinosaur);
}

/// Crea la URI al endpoint de delete dinosaur
///
/// Se pasa por parametro el id del dinosaurio a eliminar [id]. Retorna la URI correspondiente [deleteDinosaur]
Uri deleteDinosaurUri(String id) {
  Uri deleteDinosaur = Uri.http('127.0.0.1:8000', '/dinosaurs/delete/$id');
  return (deleteDinosaur);
}
