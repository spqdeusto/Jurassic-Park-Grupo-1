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

  /// Obtención de los datos
  ///
  /// Este método llama a 6 métodos, uno por cada tabla de la base de datos, para obtener toda la información que haya. Cada método hará una petición a la API. Después espera 10 segundos, y cambia la variable isLoading a false, con lo que indicará que se ha cargado toda la info correctamente y saldrá de la página de carga
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

  ///Obtiene todas las especies
  ///
  ///Llama al método de /helpers/methods getSpecies, que nos retorna una lista de especies, futureSpecies. Es un Future List porque, al ser una petición API, no se obtendrá respuesta al momento. Retorna dicha lista de especies [species] que contendrá todas las especies de la base de datos.
  obtainSpecies() async {
    Future<List<Species>> futureSpecies = getSpecies();

    species = await futureSpecies;
  }

  ///Obtiene todos los géneros
  ///
  ///Llama al método de /helpers/methods getGenders, que nos retorna una lista de géneros, futureGenders. Es un Future List porque, al ser una petición API, no se obtendrá respuesta al momento. Retorna dicha lista de generos [genders] que contendrá todos los géneros de la base de datos.
  obtainGenders() async {
    Future<List<Gender>> futureGenders = getGenders();

    genders = await futureGenders;
  }

  ///Obtiene todas las alarmas
  ///
  ///Llama al método de /helpers/methods getAlarms, que nos retorna una lista de alarmas, futureAlarms. Es un Future List porque, al ser una petición API, no se obtendrá respuesta al momento. Retorna dicha lista de alarmas [alarms] que contendrá todas las alarmas de la base de datos.
  obtainAlarms() async {
    Future<List<Alarm>> futureAlarms = getAlarms();

    alarms = await futureAlarms;
  }

  ///Obtiene todos los dinosaurios
  ///
  ///Llama al método de /helpers/methods getDinosaurs, que nos retorna una lista de dinosaurios, futureDinosaurs. Le pasaremos la lista de especies y la de generos, ya que están contenidos en el modelo de Dinosaur. Es un Future List porque, al ser una petición API, no se obtendrá respuesta al momento. Retorna dicha lista de dinosaurios [dinosaurs] que contendrá todos los dinosaurios de la base de datos.
  obtainDinosaurs() async {
    Future<List<Dinosaur>> futureDinosaurs = getDinosaurs(species, genders);

    dinosaurs = await futureDinosaurs;
  }

  ///Obtiene todos los recintos
  ///
  ///Llama al método de /helpers/methods getEnclosures, que nos retorna una lista de recintos, futureEnclosures. Le pasamos la lista de especies, ya que está contenida en el modelo Enclosure. Es un Future List porque, al ser una petición API, no se obtendrá respuesta al momento. Retorna dicha lista de recintos [enclosures] que contendrá todos los recintos de la base de datos.
  obtainEnclosures() async {
    Future<List<Enclosure>> futureEnclosures = getEnclosures(species);

    enclosures = await futureEnclosures;
  }

  ///Obtiene todas las furgonetas
  ///
  ///Llama al método de /helpers/methods getTrucks, que nos retorna una lista de furgonetas, futureTrucks. Es un Future List porque, al ser una petición API, no se obtendrá respuesta al momento. Retorna dicha lista de furgonetas [trucks] que contendrá todas las furgonetas de la base de datos.
  obtainTrucks() async {
    Future<List<Truck>> futureTrucks = getTrucks();

    trucks = await futureTrucks;
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
