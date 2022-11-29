Uri allDinosaurs() {
  Uri allDinosaurs = Uri.http('127.0.0.1:8000', '/dinosaurs');
  return (allDinosaurs);
}

Uri allSpecies() {
  Uri allSpecies = Uri.http('127.0.0.1:8000', '/species');
  return (allSpecies);
}

Uri allGenders() {
  Uri allGenders = Uri.http('127.0.0.1:8000', '/genders');
  return (allGenders);
}

Uri allAlarms() {
  Uri allAlarms = Uri.http('127.0.0.1:8000', '/alarms');
  return (allAlarms);
}

Uri allEnclosures() {
  Uri allEnclosures = Uri.http('127.0.0.1:8000', '/enclosures');
  return (allEnclosures);
}

Uri allTrucks() {
  Uri allTrucks = Uri.http('127.0.0.1:8000', '/trucks');
  return (allTrucks);
}

Uri updateEnclosure(String id) {
  Uri updateEnclosure = Uri.http('127.0.0.1:8000', '/enclosures/update/$id');
  return (updateEnclosure);
}
