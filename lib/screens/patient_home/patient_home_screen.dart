import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/models/hasta.dart';
import 'package:healmob/screens/patient_home/components/patient_bottom_navigation_bar.dart';
import 'package:healmob/screens/patient_home/pages/home_page.dart';
import 'package:healmob/screens/patient_home/pages/message_page.dart';
import 'package:healmob/screens/patient_home/pages/profile_page.dart';

class PatientHomeScreen extends StatefulWidget {
  final Hasta hasta;
  const PatientHomeScreen({Key? key, required this.hasta}) : super(key: key);

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  var _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final _screens = [
      HomePage(hasta: widget.hasta),
      MessagePage(hasta: widget.hasta),
      ProfilePage(hasta: widget.hasta)
    ];
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: PatientBottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
      ),
      body: AnimatedSwitcher(
          duration: defaultDuration, child: _screens[_selectedTab]),
    );
  }
}
