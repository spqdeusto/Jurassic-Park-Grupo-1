import 'package:flutter/material.dart';
import 'package:frontend/models/dinosaur.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../models/species.dart';

class Home extends StatefulWidget {
  List<Dinosaur> dinosaurs;
  List<Species> species;
  Home(this.dinosaurs, this.species, {Key? key}) : super(key: key);

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
                    child: Text('NUBLAR ISLAND',
                        style: GoogleFonts.basic(
                            fontSize:
                                MediaQuery.of(context).size.width / 1000 * 54,
                            color: Colors.white,
                            fontStyle: FontStyle.italic)),
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
                        Align(
                            alignment: const Alignment(0.5, -0.6),
                            child: generateZone(widget.species[1], 1)),

                        Align(
                            alignment: const Alignment(-0.4, -0.3),
                            child: generateZone(widget.species[2], 2)),
                        Align(
                            alignment: const Alignment(0, 0.3),
                            child: generateZone(widget.species[3], 3)),
                        Align(
                            alignment: const Alignment(-0.2, 0.8),
                            child: generateZone(widget.species[4], 4)),
                        Align(
                            alignment: const Alignment(0.4, 0),
                            child: generateZone(widget.species[5], 5)),
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
                width: MediaQuery.of(context).size.width * 0.18,
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  MouseRegion generateZone(Species species, int hoverIndex) {
    String iconRoute = species.name.toLowerCase() + '.png';
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
                        Text(
                          'This is the ' + species.name + ' zone',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width /
                                  2000 *
                                  38),
                        ),
                        Icon(
                          Icons.lock,
                          size: MediaQuery.of(context).size.width / 2000 * 56,
                          color: Colors.green,
                        )
                      ]),
                  content: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ListView(
                        children: [
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
