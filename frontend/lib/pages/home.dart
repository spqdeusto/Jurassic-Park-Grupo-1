import 'package:flutter/material.dart';
import 'package:frontend/models/dinosaur.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';

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

  @override
  Widget build(BuildContext context) {
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
                            child: generateZone(widget.species[0], 0)),
                        //T-Rex zone
                        Align(
                            alignment: const Alignment(0.5, -0.6),
                            child: generateZone(widget.species[1], 1)),
                        //Velociraptor zone
                        Align(
                            alignment: const Alignment(-0.4, -0.3),
                            child: generateZone(widget.species[2], 2)),
                        //Brachiosaurus and Parasaulophus zone
                        Align(
                            alignment: const Alignment(0, 0.3),
                            child: generateZone(widget.species[3], 3)),
                        //Galliminus zone
                        Align(
                            alignment: const Alignment(-0.2, 0.8),
                            child: generateZone(widget.species[5], 4)),
                        //Triceratops zone
                        Align(
                            alignment: const Alignment(0.4, 0),
                            child: generateZone(widget.species[6], 5)),
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
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      stops: [0.16, 0.16],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red,
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
                              widget.alarms[0].name,
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

  MouseRegion generateZone(Species species, int hoverIndex) {
    String iconRoute = species.name.toLowerCase() + '.png';
    //Para obtener el estado de la suguridad de una zona, obtenemos la posición en la lista de la zona cuya especie coincida con la que le pasamos, y miramos su campo "electricity"
    bool securityActivated = widget
        .enclosures[widget.enclosures
            .indexWhere((element) => element.species.id == (species.id))]
        .electricity;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext builderContext) {
                return AlertDialog(
                  insetPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2),
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        species.id != 4
                            ? Text(
                                'This is the ' + species.name + ' zone',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            2000 *
                                            38),
                              )
                            : Text(
                                'This is the ' +
                                    species.name +
                                    ' and Parasaulophus zone',
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            2000 *
                                            38),
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
                          if (species.id != 4)
                            for (var dinosaur in widget.dinosaurs)
                              if (dinosaur.species.name == species.name)
                                SizedBox(
                                  height: MediaQuery.of(context).size.height /
                                      1000 *
                                      80,
                                  child: ListTile(
                                    leading: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2000 *
                                          64,
                                      child: Image.asset("icons/$iconRoute"),
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
                                            MediaQuery.of(context).size.width /
                                                2000 *
                                                24,
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: MediaQuery.of(context).size.width *
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
                          if (species.id == 4)
                            for (var dinosaur in widget.dinosaurs)
                              if (dinosaur.species.name == species.name ||
                                  dinosaur.species.name == 'Parasaulophus')
                                SizedBox(
                                  height: MediaQuery.of(context).size.height /
                                      1000 *
                                      80,
                                  child: ListTile(
                                    leading: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2000 *
                                          64,
                                      child:
                                          dinosaur.species.name == species.name
                                              ? Image.asset("icons/$iconRoute")
                                              : Image.asset(
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
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                2000 *
                                                24,
                                      ),
                                    ),
                                    trailing: SizedBox(
                                      width: MediaQuery.of(context).size.width *
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
                      height: MediaQuery.of(context).size.height / 1000 * 68,
                      outerColor: Colors.lightBlue,
                      innerColor: Colors.white,
                      sliderButtonIconPadding:
                          MediaQuery.of(context).size.height / 1000 * 14,
                      sliderButtonIconSize:
                          MediaQuery.of(context).size.height / 1000 * 28,
                      text: 'Slide to deactivate security',
                      textStyle: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width / 2000 * 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      onSubmit: () {},
                    ),
                  ],
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
