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

  Future<bool> updateSecurity(Enclosure enclosure) async {
    bool deactivatedSuccess = await deactivateEnclosureElectricity(enclosure);
    bool obtainedDataSuccess = await obtainUpdatedData();

    setState(() {});

    return (deactivatedSuccess && obtainedDataSuccess);
  }

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

  Future<bool> obtainUpdatedData() async {
    Future<List<Alarm>> futureAlarms = getAlarms();
    widget.alarms = await futureAlarms;

    Future<List<Enclosure>> futureEnclosures = getEnclosures(widget.species);
    widget.enclosures = await futureEnclosures;

    Future<List<Truck>> futureTrucks = getTrucks();
    widget.trucks = await futureTrucks;

    return true;
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
                            child: generateZone(
                                widget.species[0], widget.enclosures[0], 0)),
                        //T-Rex zone
                        Align(
                            alignment: const Alignment(0.5, -0.6),
                            child: generateZone(
                                widget.species[1], widget.enclosures[1], 1)),
                        //Velociraptor zone
                        Align(
                            alignment: const Alignment(-0.4, -0.3),
                            child: generateZone(
                                widget.species[2], widget.enclosures[2], 2)),
                        //Brachiosaurus and Parasaulophus zone
                        Align(
                            alignment: const Alignment(0, 0.3),
                            child: generateZone(
                                widget.species[3], widget.enclosures[3], 3)),
                        //Galliminus zone
                        Align(
                            alignment: const Alignment(-0.2, 0.8),
                            child: generateZone(
                                widget.species[5], widget.enclosures[4], 4)),
                        //Triceratops zone
                        Align(
                            alignment: const Alignment(0.4, 0),
                            child: generateZone(
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
                                            child: Image.asset(
                                                "icons/truck.png",
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2000 *
                                                    64,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2000 *
                                                    64)),
                                        title: Text(
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
                                        subtitle: Text(
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  MouseRegion generateZone(
      Species species, Enclosure enclosure, int hoverIndex) {
    String iconRoute = species.name.toLowerCase() + '.png';
    //Para obtener el estado de la suguridad de una zona, obtenemos la posición en la lista de la zona cuya especie coincida con la que le pasamos, y miramos su campo "electricity"
    bool securityActivated = enclosure.electricity;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, setStateDialog) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.2),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'This is the ' + enclosure.name,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width /
                                      2000 *
                                      38),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.015,
                            ),
                            securityActivated
                                ? Icon(
                                    Icons.lock_outline,
                                    size: MediaQuery.of(context).size.width /
                                        2000 *
                                        56,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.lock_open,
                                    size: MediaQuery.of(context).size.width /
                                        2000 *
                                        56,
                                    color: Colors.red,
                                  )
                          ]),
                      content: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: ListView(
                            children: [
                              for (var dinosaur in widget.dinosaurs)
                                if (dinosaur.species.id ==
                                        enclosure.species.id ||
                                    (dinosaur.species.id == 5 &&
                                        enclosure.species.id == 4))
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1000 *
                                        80,
                                    child: ListTile(
                                      leading: dinosaur.species.id != 5
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2000 *
                                                  64,
                                              child: Image.asset(
                                                  "icons/$iconRoute"),
                                            )
                                          : SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2000 *
                                                  64,
                                              child: Image.asset(
                                                  "icons/parasaulophus.png"),
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
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2000 *
                                              24,
                                        ),
                                      ),
                                      trailing: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Icon(Icons.edit),
                                            Icon(Icons.delete),
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
                        SlideAction(
                          height:
                              MediaQuery.of(context).size.height / 1000 * 68,
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
                              fontSize:
                                  MediaQuery.of(context).size.width / 2000 * 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          onSubmit: () async {
                            bool deactivatedSuccess =
                                await updateSecurity(enclosure);
                            if (deactivatedSuccess) {
                              setStateDialog(() {
                                securityActivated = !securityActivated;
                              });
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
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
}
