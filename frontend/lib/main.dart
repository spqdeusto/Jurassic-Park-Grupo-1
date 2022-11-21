import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helpers/methods.dart';
import 'models/dinosaur.dart';
import 'models/gender.dart';
import 'models/species.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jurassic Park',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MyHomePage(title: 'Jurassic Park'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  //Borrar datos cuando esté solucionado el cors
  List<Species> species = [
    Species(1, "Dilophosaurus", true),
    Species(2, "T-Rex", true),
    Species(3, "Velociraptor", true),
    Species(4, "Brachiosaurus", false),
    Species(5, "Parasaulophus", false),
    Species(6, "Galliminus", false),
    Species(7, "Triceratops", false),
  ];
  List<Gender> genders = [
    Gender(1, "Male"),
    Gender(2, "Female"),
  ];
  List<Dinosaur> dinosaurs = [
    Dinosaur(1, "Ryan", Species(1, "Dilophosaurus", true), 20, 100,
        Gender(1, "Male")),
    Dinosaur(2, "Ryan", Species(1, "Dilophosaurus", true), 20, 100,
        Gender(2, "Female")),
    Dinosaur(3, "Ryan", Species(2, "T-Rex", true), 20, 100, Gender(1, "Male")),
    Dinosaur(7, "Ryan", Species(3, "Velociraptor", true), 20, 100,
        Gender(1, "Male")),
    Dinosaur(
        4, "Ryan", Species(2, "T-Rex", true), 20, 100, Gender(2, "Female")),
    Dinosaur(5, "Ryan", Species(4, "Brachiosaurus", false), 20, 100,
        Gender(1, "Male")),
    Dinosaur(5, "Ryan", Species(5, "Parasaulophus", false), 20, 100,
        Gender(1, "Male")),
    Dinosaur(6, "Ryan", Species(6, "Galliminus", false), 20, 100,
        Gender(2, "Female")),
    Dinosaur(8, "Ryan", Species(7, "Triceratops", false), 20, 100,
        Gender(2, "Female")),
  ];

  obtainDataApi() async {
    await obtainSpecies();
    await obtainGenders();
    await obtainDinosaurs();
    _isLoading = false;
  }

  obtainSpecies() async {
    Future<List<Species>> futureSpecies = getSpecies();

    species = await futureSpecies;

    for (var species in species) {
      print(species.name);
    }
  }

  obtainGenders() async {
    Future<List<Gender>> futureGenders = getGenders();

    genders = await futureGenders;

    for (var gender in genders) {
      print(gender.name);
    }
  }

  obtainDinosaurs() async {
    Future<List<Dinosaur>> futureDinosaurs = getDinosaurs(species, genders);

    dinosaurs = await futureDinosaurs;

    for (var dinosaur in dinosaurs) {
      print(dinosaur.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    obtainDataApi();
    return Scaffold(
      body: _isLoading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "images/logo2.png",
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.12,
                      width: MediaQuery.of(context).size.width * 0.12,
                      child: Image.asset(
                        "gifs/plane.gif",
                      ),
                    ),
                    Text('Flying to Nublar Island . . .',
                        style: GoogleFonts.basic(
                            fontSize:
                                MediaQuery.of(context).size.width / 1000 * 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ]))
          : Home(dinosaurs, species),
    );
  }
}
