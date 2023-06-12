import 'package:barterit_asgm2/user.dart';
import 'package:flutter/material.dart';
import 'addscreen.dart';
import 'listscreen.dart';
import 'messagescreen.dart';
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
      ListScreen(user: widget.user),
      AddScreen(user: widget.user),
      MessageSceen(user: widget.user),
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
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                backgroundColor: Colors.orange,
                icon: Icon(
                  Icons.change_circle_outlined,
                ),
                label: "Barter"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
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
      if (_currentIndex == 2) {
        maintitle = "Messages";
      }
      if (_currentIndex == 3) {
        maintitle = "Profile";
      }
    });
  }
}
