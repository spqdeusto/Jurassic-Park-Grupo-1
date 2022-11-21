import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/loadingPage.dart';
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingPage(),
    );
  }
}
