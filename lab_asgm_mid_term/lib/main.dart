import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screen/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyNelayan',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}
