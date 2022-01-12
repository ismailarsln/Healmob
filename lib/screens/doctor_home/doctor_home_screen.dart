import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healmob/components/bottom_navigation_bar.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/notification_service.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/screens/doctor_home/pages/home_page.dart';
import 'package:healmob/screens/doctor_home/pages/message_page.dart';
import 'package:healmob/screens/doctor_home/pages/profile_page.dart';

class DoctorHomeScreen extends StatefulWidget {
  final Doktor doktor;
  const DoctorHomeScreen({Key? key, required this.doktor}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  void initState() {
    FirebaseMessaging.instance
        .getToken()
        .then(
          (value) => NotificationApi.unSubscribeAllTopicsWithoutOneKey(value!,
              "${widget.doktor.doktorNo}_${widget.doktor.email.replaceAll("@", "_")}"),
        )
        .then(
          (value) => {
            FirebaseMessaging.instance.subscribeToTopic(
                "${widget.doktor.doktorNo}_${widget.doktor.email.replaceAll("@", "_")}")
          },
        );

    FirebaseMessaging.onMessage.listen((message) {
      _showAlert(
          context, message.notification!.title!, message.notification!.body!);
    });
    super.initState();
  }

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
      bottomNavigationBar: MyBottomNavigationBar(
        isPatient: false,
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

  void _showAlert(BuildContext context, String title, String message) {
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
