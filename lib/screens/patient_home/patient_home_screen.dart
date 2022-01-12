import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/notification_service.dart';
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
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then(
          (value) => NotificationApi.unSubscribeAllTopicsWithoutOneKey(value!,
                  "${widget.hasta.hastaNo}_${widget.hasta.email.replaceAll("@", "_")}")
              .then(
            (val) {
              FirebaseMessaging.instance.subscribeToTopic(
                  "${widget.hasta.hastaNo}_${widget.hasta.email.replaceAll("@", "_")}");
            },
          ),
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

  void _showAlert(BuildContext context, String title, String message) {
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
