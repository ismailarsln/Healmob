import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/mesaj_api.dart';
import 'package:healmob/models/api_response/api_get_response.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/models/mesaj.dart';

class HomePage extends StatefulWidget {
  final Doktor doktor;
  const HomePage({Key? key, required this.doktor}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int unreadMessages = 0;

  @override
  void initState() {
    getNumberOfUnreadMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [appSecondDarkColor, appSecondColor]),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            "Hoşgeldiniz Doktor\n${widget.doktor.ad.replaceFirst(widget.doktor.ad[0], widget.doktor.ad[0].toUpperCase())} ${widget.doktor.cinsiyet ? 'Hanım' : 'Bey'}",
                            style: const TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: appSecondDarkColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    offset: Offset(4.0, 4.0),
                  )
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    "Bugün, cevaplanmayı bekleyen\n$unreadMessages mesajınız var",
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getNumberOfUnreadMessages() {
    MesajApi.getAllByDoktorNo(widget.doktor.doktorNo).then((response) {
      var apiResponse = ApiGetResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        for (int i = 0; i < apiResponse.data.length; i++) {
          var message = Mesaj.fromJson(apiResponse.data[i]);
          if (message.doktorYanit == null) {
            setState(() {
              unreadMessages++;
            });
          }
        }
      }
    });
  }
}
