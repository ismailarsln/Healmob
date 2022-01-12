import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final ValueChanged<int> onTap;
  final bool isPatient;
  const MyBottomNavigationBar(
      {Key? key, required this.onTap, required this.isPatient})
      : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: widget.isPatient ? appPrimaryColor : appSecondColor,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 450),
      height: 60,
      items: navIcons,
      onTap: widget.onTap,
    );
  }
}

const List<Icon> navIcons = [
  Icon(
    Icons.home_rounded,
    color: Colors.white,
    size: 32.0,
  ),
  Icon(
    Icons.message,
    color: Colors.white,
    size: 32.0,
  ),
  Icon(
    Icons.person,
    color: Colors.white,
    size: 32.0,
  )
];
