import 'package:barterit_asgm2/user.dart';
import 'package:flutter/material.dart';
import 'listscreen.dart';
import 'viewscreen.dart';
//import 'login.dart';
import 'profilescreen.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Barter";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("Mainscreen");
    tabchildren = [
      ViewScreen(user: widget.user),
      ListScreen(user: widget.user),
      //LoginScreen(user: widget.user),
      ProfileScreen(user: widget.user)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.change_circle_outlined,
                ),
                label: "Barter"),
            BottomNavigationBarItem(
                backgroundColor: Colors.orange,
                icon: Icon(
                  Icons.list_alt_rounded,
                ),
                label: "List"),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.lock_person_outlined,
            //     ),
            //     label: "Login"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle_rounded,
                ),
                label: "Profile")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "Barter";
      }
      // if (_currentIndex == 2) {
      //   maintitle = "Messages";
      // }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}
