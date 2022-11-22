import 'package:flutter/material.dart';
import 'package:frontend/models/enclosure.dart';
import 'package:frontend/models/truck.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/methods.dart';
import '../models/alarm.dart';
import '../models/dinosaur.dart';
import '../models/gender.dart';
import '../models/species.dart';
import 'home.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _isLoading = true;

  List<Species> species = [];
  List<Gender> genders = [];
  List<Dinosaur> dinosaurs = [];
  List<Alarm> alarms = [];
  List<Enclosure> enclosures = [];
  List<Truck> trucks = [];

  obtainDataApi() async {
    await obtainSpecies();
    await obtainGenders();
    await obtainAlarms();
    await obtainDinosaurs();
    await obtainEnclosures();
    await obtainTrucks();

    await Future.delayed(const Duration(seconds: 10));

    setState(() {
      _isLoading = false;
    });
  }

  obtainSpecies() async {
    Future<List<Species>> futureSpecies = getSpecies();

    species = await futureSpecies;

    for (var item in species) {
      print(item.name);
    }
  }

  obtainGenders() async {
    Future<List<Gender>> futureGenders = getGenders();

    genders = await futureGenders;

    for (var item in genders) {
      print(item.name);
    }
  }

  obtainAlarms() async {
    Future<List<Alarm>> futureAlarms = getAlarms();

    alarms = await futureAlarms;

    for (var item in alarms) {
      print(item.name);
    }
  }

  obtainDinosaurs() async {
    Future<List<Dinosaur>> futureDinosaurs = getDinosaurs(species, genders);

    dinosaurs = await futureDinosaurs;

    for (var item in dinosaurs) {
      print(item.name);
    }
  }

  obtainEnclosures() async {
    Future<List<Enclosure>> futureEnclosures = getEnclosures(species);

    enclosures = await futureEnclosures;

    for (var item in enclosures) {
      print(item.name);
    }
  }

  obtainTrucks() async {
    Future<List<Truck>> futureTrucks = getTrucks();

    trucks = await futureTrucks;

    for (var item in trucks) {
      print(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      obtainDataApi();
    }

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
          : Home(species, genders, dinosaurs, alarms, enclosures, trucks),
    );
  }
}
