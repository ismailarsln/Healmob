import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';

class PatientBottomNavigationBar extends StatefulWidget {
  final ValueChanged<int> onTap;
  const PatientBottomNavigationBar({Key? key, required this.onTap})
      : super(key: key);

  @override
  State<PatientBottomNavigationBar> createState() =>
      _PatientBottomNavigationBarState();
}

class _PatientBottomNavigationBarState
    extends State<PatientBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: appPrimaryDarkColor,
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
