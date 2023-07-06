// import "dart:async";
// import 'package:barterit_asgm2/Screen/login.dart';
// import "package:flutter/material.dart";

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(
//         const Duration(seconds: 3),
//         () => Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (content) => const LoginScreen())));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 104, 198, 184),
//         body: Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                   image: DecorationImage(
//                       image: AssetImage('assets/images/splash.jpg'),
//                       fit: BoxFit.contain)),
//               alignment: Alignment.center,
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 450, 0, 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text(
//                     "BarterIt",
//                     style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
//                   ),
//                   CircularProgressIndicator(
//                     color: Colors.black,
//                   ),
//                   // Text(
//                   //   "Version 0.1",
//                   //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   // )
//                 ],
//               ),
//             )
//           ],
//         ));
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barterit_asgm2/user.dart';
import 'package:barterit_asgm2/Screen/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:barterit_asgm2/config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAndLogin();
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

  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        http.post(Uri.parse("${Config().server}/barterit/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            user = User.fromJson(jsondata['data']);
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          } else {
            user = User(id: "na", name: "na", email: "na", password: "na");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: user))));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          // Time has run out, do what you wanted to do.
        });
      } on TimeoutException catch (_) {
        print("Time out");
      }
    } else {
      user = User(id: "na", name: "na", email: "na", password: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    }
  }
}
