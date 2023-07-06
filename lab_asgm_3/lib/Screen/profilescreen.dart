// import 'package:barterit_asgm2/user.dart';
// //import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'register.dart';
// import 'login.dart';

// class ProfileScreen extends StatefulWidget {
//   final User user;

//   const ProfileScreen({super.key, required this.user});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late List<Widget> tabchildren;
//   String maintitle = "Profile";
//   late double screenHeight, screenWidth, cardwitdh;
//   @override
//   void initState() {
//     super.initState();
//     print("Profile");
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     print("dispose");
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(maintitle),
//       ),
//       body: Center(
//         child: Column(children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             height: screenHeight * 0.25,
//             width: screenWidth,
//             child: Card(
//               child:
//                   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 Container(
//                   margin: const EdgeInsets.all(4),
//                   width: screenWidth * 0.4,
//                   child: Image.asset(
//                     "assets/images/profile.jpg",
//                   ),
//                 ),
//                 Expanded(
//                     flex: 6,
//                     child: Column(
//                       children: [
//                         Text(
//                           widget.user.name.toString(),
//                           style: const TextStyle(fontSize: 24),
//                         ),
//                         Text(widget.user.email.toString()),
//                       ],
//                     )),
//               ]),
//             ),
//           ),
//           Container(
//             width: screenWidth,
//             alignment: Alignment.center,
//             color: Theme.of(context).colorScheme.background,
//             child: const Padding(
//               padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
//               child: Text("PROFILE SETTINGS",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   )),
//             ),
//           ),
//           Expanded(
//               child: ListView(
//             children: [
//               MaterialButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (content) => const LoginScreen()));
//                 },
//                 child: const Text("LOGIN"),
//               ),
//               MaterialButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (content) => const RegisterScreen()));
//                 },
//                 child: const Text("REGISTRATION"),
//               ),
//             ],
//           ))
//         ]),
//       ),
//     );
//   }
// }

import 'package:barterit_asgm2/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardwitdh;
  @override
  void initState() {
    super.initState();
    print("Profile");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: Center(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: screenHeight * 0.25,
            width: screenWidth,
            child: Card(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: screenWidth * 0.4,
                  child: Image.asset(
                    "assets/images/profile.jpg",
                  ),
                ),
                Flexible(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.user.name.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        Text(widget.user.email.toString()),
                      ],
                    )),
              ]),
            ),
          ),
          Container(
            width: screenWidth,
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.background,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: Text("PROFILE SETTINGS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              LoginScreen(user: widget.user)));
                },
                child: const Text("Logout"),
              ),
              // MaterialButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (content) =>
              //                 RegisterScreen(user: widget.user)));
              //   },
              //   child: const Text("REGISTRATION"),
              // ),
            ],
          ))
        ]),
      ),
    );
  }
}
