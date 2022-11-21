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
