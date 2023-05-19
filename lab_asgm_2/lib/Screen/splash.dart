import "dart:async";
import 'package:barterit_asgm2/Screen/login.dart';
import "package:flutter/material.dart";
import 'package:barterit_asgm2/Screen/mainscreen.dart';
import 'package:barterit_asgm2/Screen/register.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 104, 198, 184),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/splash.jpg'),
                      fit: BoxFit.contain)),
              alignment: Alignment.center,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 450, 0, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "BarterIt",
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                  // Text(
                  //   "Version 0.1",
                  //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  // )
                ],
              ),
            )
          ],
        ));
  }
}
