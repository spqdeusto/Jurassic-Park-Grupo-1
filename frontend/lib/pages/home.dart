import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/helpers/urls.dart';
import 'package:frontend/models/dinosaur.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../helpers/methods.dart';
import '../models/alarm.dart';
import '../models/enclosure.dart';
import '../models/gender.dart';
import '../models/species.dart';
import '../models/truck.dart';

class Home extends StatefulWidget {
  List<Species> species;
  List<Gender> genders;
  List<Dinosaur> dinosaurs;
  List<Alarm> alarms;
  List<Enclosure> enclosures;
  List<Truck> trucks;
  Home(this.species, this.genders, this.dinosaurs, this.alarms, this.enclosures,
      this.trucks,
      {Key? key})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //For changing the color from an enclosure when hovering it, we have create a list of bools, one for each enclosure. So, when an enclosure is not beeing hovered, it is false, when it is, true. There is one value for each enclosur: Position [0] = Dilophosaurus Hover, Position [1] = T-Rex Hover, Position [2] = Velociraptor Hover, Position [3] = Brachiosaurus Hover, Position [4] = Galliminus Hover, Position [5] = Triceratops Hover,
  List<bool> enclosuresHover = [false, false, false, false, false, false];

  /// Actualiza la seguridad de las alarmas
  ///
  /// Llama al método deactivateEnclosureElectricity, al que le pasa el recinto al que estamos activando o desactivando la seguridad [enclosure]. Después llama al método obtainUpdatedData para actualizar la información de las alarmas, enclosures y trucks. Cada método retorna true si es exitoso y falso si se produce un error. En caso de que ambos sean exitosos retorna true, en caso contrario, false.
  Future<bool> updateSecurity(Enclosure enclosure) async {
    bool deactivatedSuccess = await deactivateEnclosureElectricity(enclosure);
    bool obtainedDataSuccess = await obtainUpdatedData();

    setState(() {});

    return (deactivatedSuccess && obtainedDataSuccess);
  }

  /// Método que desactiva o activa la seguridad de un recinto
  ///
  /// Recibe el recinto a modificar [enclosure] y se crea un cuerpo json con los campos de [enclosure], pero cambiando la seguridad (si era true pasa a false y viceversa). Llama al endpoint de update de un recinto, utilizando la URI de helpers/urls updateEnclosure, que contiene la URI correspondiente, a la que le añadimos el id del enclosure a modificar. En el backend, esto actualiza los datos del recinto, además de modificar el estado de las alarmas y el piloto automático de las furgonetas. Retorna true si el codigo de respuesta es exitoso (200) y false en caso contrario
  Future<bool> deactivateEnclosureElectricity(Enclosure enclosure) async {
    Client client = http.Client();
    var bodyEncoded = jsonEncode({
      "id": enclosure.id.toString(),
      "name": enclosure.name,
      "species": enclosure.species.id.toString(),
      "electricity": (!enclosure.electricity).toString()
    });

    var response = await client.put(updateEnclosure(enclosure.id.toString()),
        headers: {"Content-Type": "application/json"}, body: bodyEncoded);

    if (response.statusCode == 200) {
      setState(() {
        widget
            .enclosures[widget.enclosures
                .indexWhere((element) => element.id == enclosure.id)]
            .electricity = !enclosure.electricity;
      });
      return true;
    }
    return false;
  }

  /// Obtiene la información actualizada de la base de datos
  ///
  /// Obtiene de nuevo todas las alarmas, recintos y furgonetas con la información actualizadas de la base de datos, mediante los métodos de helpers/methods getAlarms, getEnclosures y getTrucks. Retorna true si el codigo de respuesta es exitoso (200) y false en caso contrario
  Future<bool> obtainUpdatedData() async {
    Future<List<Alarm>> futureAlarms = getAlarms();
    widget.alarms = await futureAlarms;

    Future<List<Enclosure>> futureEnclosures = getEnclosures(widget.species);
    widget.enclosures = await futureEnclosures;

    Future<List<Truck>> futureTrucks = getTrucks();
    widget.trucks = await futureTrucks;

    return true;
  }

  /// Actualiza el onRute de un Truck
  ///
  /// Llama al método updateTruck, al que le pasa el truck al que estamos activando o desactivando el campo onRute [truck]. Después llama al método obtainUpdatedData para actualizar la información de las alarmas, trucks y enclosures. Cada método retorna true si es exitoso y falso si se produce un error. En caso de que ambos sean exitosos retorna true, en caso contrario, false.
  Future<bool> updateTruck(Truck truck) async {
    bool updateTruck = await changeTruckOnRoute(truck);
    bool obtainedDataSuccess = await obtainUpdatedData();

    setState(() {});

    return (updateTruck && obtainedDataSuccess);
  }

  /// Método que desactiva o activa la seguridad de un recinto
  ///
  /// Recibe el recinto a modificar [enclosure] y se crea un cuerpo json con los campos de [enclosure], pero cambiando la seguridad (si era true pasa a false y viceversa). Llama al endpoint de update de un recinto, utilizando la URI de helpers/urls updateEnclosure, que contiene la URI correspondiente, a la que le añadimos el id del enclosure a modificar. En el backend, esto actualiza los datos del recinto, además de modificar el estado de las alarmas y el piloto automático de las furgonetas. Retorna true si el codigo de respuesta es exitoso (200) y false en caso contrario
  Future<bool> changeTruckOnRoute(Truck truck) async {
    // Si cambiamos el onRute de un truck para ponerlo a false, cambiamos su número de pasajeros a 0. Si cambiamos el de uno a true, ponemos a 4 sus pasajeros.
    int passengers = 0;
    if (!truck.onRute) passengers = 4;
    Client client = http.Client();
    var bodyEncoded = jsonEncode({
      "id": truck.id.toString(),
      "onRute": (!truck.onRute).toString(),
      "passengers": passengers.toString(),
      "securitySystem": truck.securitySystem.toString()
    });

    var response = await client.put(updateTruckUri(truck.id.toString()),
        headers: {"Content-Type": "application/json"}, body: bodyEncoded);

    if (response.statusCode == 200) {
      setState(() {
        widget
            .trucks[
                widget.trucks.indexWhere((element) => element.id == truck.id)]
            .onRute = !truck.onRute;
      });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Alarm currentAlarm =
        widget.alarms.where((element) => element.active == true).first;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        child: Row(
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width * 0.2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Image.asset(
                  "images/logo2.png",
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Text(
                      'NUBLAR ISLAND',
                      style: GoogleFonts.basic(
                          fontSize:
                              MediaQuery.of(context).size.width / 2000 * 108,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.85,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Image.asset(
                            "images/mapa.png",
                          ),
                        ),
                        //Dilophosaurus zone
                        Align(
                            alignment: const Alignment(-0.7, -0.7),
                            child: generateZoneIcon(
                                widget.species[0], widget.enclosures[0], 0)),
                        //T-Rex zone
                        Align(
                            alignment: const Alignment(0.5, -0.6),
                            child: generateZoneIcon(
                                widget.species[1], widget.enclosures[1], 1)),
                        //Velociraptor zone
                        Align(
                            alignment: const Alignment(-0.4, -0.3),
                            child: generateZoneIcon(
                                widget.species[2], widget.enclosures[2], 2)),
                        //Brachiosaurus and Parasaulophus zone
                        Align(
                            alignment: const Alignment(0, 0.3),
                            child: generateZoneIcon(
                                widget.species[3], widget.enclosures[3], 3)),
                        //Galliminus zone
                        Align(
                            alignment: const Alignment(-0.2, 0.8),
                            child: generateZoneIcon(
                                widget.species[5], widget.enclosures[4], 4)),
                        //Triceratops zone
                        Align(
                            alignment: const Alignment(0.4, 0),
                            child: generateZoneIcon(
                                widget.species[6], widget.enclosures[5], 5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              alignment: const Alignment(-1, 0.8),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.19,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: const [0.16, 0.16],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: currentAlarm.id == 1
                          ? [
                              Colors.red,
                              Colors.white,
                            ]
                          : currentAlarm.id == 2
                              ? [
                                  Colors.orange,
                                  Colors.white,
                                ]
                              : currentAlarm.id == 3
                                  ? [
                                      const Color.fromARGB(255, 219, 198, 15),
                                      Colors.white,
                                    ]
                                  : [
                                      Colors.green,
                                      Colors.white,
                                    ],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.19,
                        height: MediaQuery.of(context).size.height * 0.063,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.security,
                              color: Colors.white,
                              size:
                                  MediaQuery.of(context).size.width / 2000 * 44,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Text(
                              currentAlarm.name,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width /
                                      2000 *
                                      30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.19,
                              height: MediaQuery.of(context).size.height * 0.36,
                              child: ListView(
                                children: [
                                  for (var truck in widget.trucks)
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: ListTile(
                                        leading: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            child: Tooltip(
                                              message: truck.onRute
                                                  ? 'Truck on route'
                                                  : 'Truck not on route',
                                              child: MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      updateTruck(truck);
                                                    });
                                                  },
                                                  child: Opacity(
                                                    opacity:
                                                        truck.onRute ? 1 : 0.6,
                                                    child: Image.asset(
                                                        "icons/truck.png",
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2000 *
                                                            64,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2000 *
                                                            64),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        title: Opacity(
                                          opacity: truck.onRute ? 1 : 0.6,
                                          child: Text(
                                            'Truck nº' + truck.id.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2000 *
                                                  26,
                                            ),
                                          ),
                                        ),
                                        subtitle: Opacity(
                                          opacity: truck.onRute ? 1 : 0.6,
                                          child: Text(
                                            truck.passengers.toString() +
                                                ' passengers',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2000 *
                                                  22,
                                            ),
                                          ),
                                        ),
                                        trailing: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          child: Tooltip(
                                            message: truck.securitySystem
                                                ? 'Auto-Pilot activated'
                                                : 'Auto-Pilot not activated',
                                            child: Icon(
                                              Icons.check_box,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2000 *
                                                  44,
                                              color: truck.securitySystem
                                                  ? Colors.green
                                                  : const Color.fromARGB(
                                                      106, 76, 175, 79),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ))),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MouseRegion generateZoneIcon(
      Species species, Enclosure enclosure, int hoverIndex) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return zoneAlertDialog(species, enclosure, hoverIndex);
              });
        },
        onHover: (hover) {
          setState(() {
            if (hover) {
              enclosuresHover[hoverIndex] = true;
            } else {
              enclosuresHover[hoverIndex] = false;
            }
          });
        },
        child: Icon(
          Icons.location_on,
          color: enclosuresHover[hoverIndex]
              ? Colors.white
              : const Color.fromARGB(255, 26, 22, 22),
          size: MediaQuery.of(context).size.height / 1000 * 64,
        ),
      ),
    );
  }

  StatefulBuilder zoneAlertDialog(
      Species species, Enclosure enclosure, int hoverIndex) {
    //Para obtener el estado de la suguridad de una zona, obtenemos la posición en la lista de la zona cuya especie coincida con la que le pasamos, y miramos su campo "electricity"
    bool securityActivated = enclosure.electricity;
    String iconRoute = species.name.toLowerCase() + '.png';
    return StatefulBuilder(
      builder: (BuildContext context, setStateDialog) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'This is the ' + enclosure.name,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 2000 * 38),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.015,
            ),
            securityActivated
                ? Icon(
                    Icons.lock_outline,
                    size: MediaQuery.of(context).size.width / 2000 * 56,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.lock_open,
                    size: MediaQuery.of(context).size.width / 2000 * 56,
                    color: Colors.red,
                  )
          ]),
          content: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.3,
              child: ListView(
                children: [
                  for (var dinosaur in widget.dinosaurs)
                    if (dinosaur.species.id == enclosure.species.id ||
                        (dinosaur.species.id == 5 && enclosure.species.id == 4))
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 1000 * 80,
                        child: ListTile(
                          leading: dinosaur.species.id != 5
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      2000 *
                                      64,
                                  child: Image.asset("icons/$iconRoute"),
                                )
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width /
                                      2000 *
                                      64,
                                  child: Image.asset("icons/parasaulophus.png"),
                                ),
                          title: Text(
                            dinosaur.name.toUpperCase() +
                                ', ' +
                                dinosaur.age.toString() +
                                ' ages' +
                                ' and ' +
                                dinosaur.weight.toString() +
                                ' kilos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width / 2000 * 24,
                            ),
                          ),
                          trailing: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return editDinosaurAlertDialog(
                                                  species,
                                                  enclosure,
                                                  hoverIndex,
                                                  dinosaur);
                                            });
                                      },
                                      child: const Icon(Icons.edit)),
                                ),
                                MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () async {
                                          bool success =
                                              await deleteDinosaur(dinosaur.id);
                                          if (success) {
                                            setStateDialog(() {
                                              widget.dinosaurs.removeAt(widget
                                                  .dinosaurs
                                                  .indexOf(dinosaur));
                                            });
                                          }
                                        },
                                        child: const Icon(Icons.delete))),
                              ],
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          actions: [
            Column(children: [
              Align(
                alignment: const Alignment(0.9, 1),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return newDinosaurAlertDialog(species, enclosure,
                                hoverIndex, widget.dinosaurs.last.id + 1);
                          });
                    },
                    child: Text(
                      'Add a new one',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize:
                              MediaQuery.of(context).size.height / 1000 * 26),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SlideAction(
                height: MediaQuery.of(context).size.height / 1000 * 68,
                outerColor: Colors.lightBlue,
                innerColor: Colors.white,
                sliderButtonIconPadding:
                    MediaQuery.of(context).size.height / 1000 * 14,
                sliderButtonIconSize:
                    MediaQuery.of(context).size.height / 1000 * 28,
                text: securityActivated
                    ? 'Slide to deactivate security'
                    : 'Slide to activate security',
                textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 2000 * 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                onSubmit: () async {
                  bool deactivatedSuccess = await updateSecurity(enclosure);
                  if (deactivatedSuccess) {
                    setStateDialog(() {
                      securityActivated = !securityActivated;
                    });
                  }
                },
              ),
            ]),
          ],
        );
      },
    );
  }

  StatefulBuilder newDinosaurAlertDialog(Species species, Enclosure enclosure,
      int hoverIndex, int nextDinosaurId) {
    Color textFieldColor = const Color.fromARGB(255, 222, 213, 213);
    Color textFieldText = Colors.black;
    Color textFieldHintText = const Color.fromARGB(255, 108, 107, 107);
    Color textFieldIcon = const Color.fromARGB(255, 53, 50, 50);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    bool _userError = false;
    String iconRoute = species.name.toLowerCase() + '.png';
    Gender? selectedGender = widget.genders[0];
    Species? selectedSpecies = species;
    return StatefulBuilder(builder: (BuildContext context, setStateDialog) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2),
        title: Text(
          'Add a new ' + species.name,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 2000 * 38),
        ),
        content: Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.145,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    color: textFieldColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2000 * 12,
                      top: MediaQuery.of(context).size.width / 2000 * 5,
                      bottom: MediaQuery.of(context).size.width / 2000 * 6,
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: textFieldText,
                        fontSize: MediaQuery.of(context).size.width / 1000 * 18,
                      ),
                      controller: nameController,
                      decoration: InputDecoration(
                          icon: Image.asset(
                            "icons/$iconRoute",
                            color: _userError ? Colors.red : textFieldIcon,
                            height:
                                MediaQuery.of(context).size.width / 1000 * 20,
                          ),
                          border: InputBorder.none,
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: textFieldHintText,
                            fontSize:
                                MediaQuery.of(context).size.width / 1000 * 16,
                          )),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.145,
                  height: MediaQuery.of(context).size.height * 0.06,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: textFieldColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Gender>(
                      underline: Container(
                        color: textFieldText,
                        height: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      dropdownColor: textFieldColor,
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width / 1000 * 16,
                          color: textFieldText),
                      iconSize: 32,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: textFieldIcon,
                      ),
                      isExpanded: true,
                      value: selectedGender,
                      items: widget.genders.map(genderMenu).toList(),
                      onChanged: (value) => setStateDialog(() {
                        selectedGender = value;
                      }),
                    ),
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.145,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: textFieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 2000 * 12,
                        top: MediaQuery.of(context).size.width / 2000 * 5,
                        bottom: MediaQuery.of(context).size.width / 2000 * 6,
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: textFieldText,
                          fontSize:
                              MediaQuery.of(context).size.width / 1000 * 18,
                        ),
                        controller: ageController,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.cake,
                              color: _userError ? Colors.red : textFieldIcon,
                              size:
                                  MediaQuery.of(context).size.width / 1000 * 20,
                            ),
                            border: InputBorder.none,
                            hintText: 'Age',
                            hintStyle: TextStyle(
                              color: textFieldHintText,
                              fontSize:
                                  MediaQuery.of(context).size.width / 1000 * 16,
                            )),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.145,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: textFieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 2000 * 12,
                        top: MediaQuery.of(context).size.width / 2000 * 5,
                        bottom: MediaQuery.of(context).size.width / 2000 * 6,
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: textFieldText,
                          fontSize:
                              MediaQuery.of(context).size.width / 1000 * 18,
                        ),
                        controller: weightController,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.monitor_weight_sharp,
                              color: _userError ? Colors.red : textFieldIcon,
                              size:
                                  MediaQuery.of(context).size.width / 1000 * 20,
                            ),
                            border: InputBorder.none,
                            hintText: 'Weight',
                            hintStyle: TextStyle(
                              color: textFieldHintText,
                              fontSize:
                                  MediaQuery.of(context).size.width / 1000 * 16,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.16,
                height: MediaQuery.of(context).size.height * 0.06,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: textFieldColor,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Species>(
                    underline: Container(
                      color: textFieldText,
                      height: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    dropdownColor: textFieldColor,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 1000 * 16,
                        color: textFieldText),
                    iconSize: 32,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: textFieldIcon,
                    ),
                    isExpanded: true,
                    value: selectedSpecies,
                    items: widget.species.map(speciesMenu).toList(),
                    onChanged: (value) => setStateDialog(() {
                      selectedSpecies = value;
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  Dinosaur newDinosaur = Dinosaur(
                      nextDinosaurId,
                      nameController.text,
                      selectedSpecies!,
                      int.parse(ageController.text),
                      double.parse(weightController.text),
                      selectedGender!);
                  int newID = await createDinosaur(newDinosaur);

                  setState(() {
                    if (newID != 0) {
                      newDinosaur.id = newID;
                      widget.dinosaurs.add(newDinosaur);
                    }
                  });

                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return zoneAlertDialog(species, enclosure, hoverIndex);
                      });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 1000 * 14,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }

  StatefulBuilder editDinosaurAlertDialog(
      Species species, Enclosure enclosure, int hoverIndex, Dinosaur dinosaur) {
    Color textFieldColor = const Color.fromARGB(255, 222, 213, 213);
    Color textFieldText = Colors.black;
    Color textFieldHintText = const Color.fromARGB(255, 108, 107, 107);
    Color textFieldIcon = const Color.fromARGB(255, 53, 50, 50);
    final TextEditingController nameController =
        TextEditingController(text: dinosaur.name);
    final TextEditingController ageController =
        TextEditingController(text: dinosaur.age.toString());
    final TextEditingController weightController =
        TextEditingController(text: dinosaur.weight.toString());
    bool _userError = false;
    String iconRoute = species.name.toLowerCase() + '.png';
    Gender? selectedGender = dinosaur.gender;
    Species? selectedSpecies = dinosaur.species;
    return StatefulBuilder(builder: (BuildContext context, setStateDialog) {
      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2),
        title: Text(
          'Edit this ' + species.name,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width / 2000 * 38),
        ),
        content: Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.145,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    color: textFieldColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2000 * 12,
                      top: MediaQuery.of(context).size.width / 2000 * 5,
                      bottom: MediaQuery.of(context).size.width / 2000 * 6,
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: textFieldText,
                        fontSize: MediaQuery.of(context).size.width / 1000 * 18,
                      ),
                      controller: nameController,
                      decoration: InputDecoration(
                          icon: Image.asset(
                            "icons/$iconRoute",
                            color: _userError ? Colors.red : textFieldIcon,
                            height:
                                MediaQuery.of(context).size.width / 1000 * 20,
                          ),
                          border: InputBorder.none,
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: textFieldHintText,
                            fontSize:
                                MediaQuery.of(context).size.width / 1000 * 16,
                          )),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.145,
                  height: MediaQuery.of(context).size.height * 0.06,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: textFieldColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Gender>(
                      underline: Container(
                        color: textFieldText,
                        height: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      dropdownColor: textFieldColor,
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width / 1000 * 16,
                          color: textFieldText),
                      iconSize: 32,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: textFieldIcon,
                      ),
                      isExpanded: true,
                      value: selectedGender,
                      items: widget.genders.map(genderMenu).toList(),
                      onChanged: (value) => setStateDialog(() {
                        selectedGender = value;
                      }),
                    ),
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.145,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: textFieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 2000 * 12,
                        top: MediaQuery.of(context).size.width / 2000 * 5,
                        bottom: MediaQuery.of(context).size.width / 2000 * 6,
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: textFieldText,
                          fontSize:
                              MediaQuery.of(context).size.width / 1000 * 18,
                        ),
                        controller: ageController,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.cake,
                              color: _userError ? Colors.red : textFieldIcon,
                              size:
                                  MediaQuery.of(context).size.width / 1000 * 20,
                            ),
                            border: InputBorder.none,
                            hintText: 'Age',
                            hintStyle: TextStyle(
                              color: textFieldHintText,
                              fontSize:
                                  MediaQuery.of(context).size.width / 1000 * 16,
                            )),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.145,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      color: textFieldColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 2000 * 12,
                        top: MediaQuery.of(context).size.width / 2000 * 5,
                        bottom: MediaQuery.of(context).size.width / 2000 * 6,
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: textFieldText,
                          fontSize:
                              MediaQuery.of(context).size.width / 1000 * 18,
                        ),
                        controller: weightController,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.monitor_weight_sharp,
                              color: _userError ? Colors.red : textFieldIcon,
                              size:
                                  MediaQuery.of(context).size.width / 1000 * 20,
                            ),
                            border: InputBorder.none,
                            hintText: 'Weight',
                            hintStyle: TextStyle(
                              color: textFieldHintText,
                              fontSize:
                                  MediaQuery.of(context).size.width / 1000 * 16,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.16,
                height: MediaQuery.of(context).size.height * 0.06,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: textFieldColor,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Species>(
                    underline: Container(
                      color: textFieldText,
                      height: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    dropdownColor: textFieldColor,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 1000 * 16,
                        color: textFieldText),
                    iconSize: 32,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: textFieldIcon,
                    ),
                    isExpanded: true,
                    value: selectedSpecies,
                    items: widget.species.map(speciesMenu).toList(),
                    onChanged: (value) => setStateDialog(() {
                      selectedSpecies = value;
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  Dinosaur updatedDinosaur = Dinosaur(
                      dinosaur.id,
                      nameController.text,
                      selectedSpecies!,
                      int.parse(ageController.text),
                      double.parse(weightController.text),
                      selectedGender!);
                  bool success = await updateDinosaur(updatedDinosaur);

                  setState(() {
                    if (success) {
                      widget.dinosaurs[widget.dinosaurs.indexOf(dinosaur)] =
                          updatedDinosaur;
                    }
                  });

                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return zoneAlertDialog(species, enclosure, hoverIndex);
                      });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 1000 * 14,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }

  DropdownMenuItem<Species> speciesMenu(Species species) => DropdownMenuItem(
        value: species,
        child: Text(
          species.name,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      );

  DropdownMenuItem<Gender> genderMenu(Gender gender) => DropdownMenuItem(
        value: gender,
        child: Text(
          gender.name,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      );
}
