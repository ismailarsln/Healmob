import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/screens/doctor_home/pages/home_page.dart';
import 'package:healmob/screens/doctor_home/pages/message_page.dart';
import 'package:healmob/screens/doctor_home/pages/profile_page.dart';
import 'package:healmob/screens/patient_home/components/patient_bottom_navigation_bar.dart';

class DoctorHomeScreen extends StatefulWidget {
  final Doktor doktor;
  const DoctorHomeScreen({Key? key, required this.doktor}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  var _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final _screens = [
      HomePage(doktor: widget.doktor),
      MessagePage(doktor: widget.doktor),
      ProfilePage(doktor: widget.doktor)
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
