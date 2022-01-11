import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healmob/data/doktor_api.dart';
import 'package:healmob/data/mesaj_api.dart';
import 'package:healmob/models/api_response/api_get_response.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/models/hasta.dart';
import 'package:healmob/models/mesaj.dart';
import 'package:healmob/screens/patient_home/message_screen.dart';

class MessagePage extends StatefulWidget {
  final Hasta hasta;
  const MessagePage({Key? key, required this.hasta}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Mesaj> hastaMesajList = <Mesaj>[];
  List<Doktor> doktorList = <Doktor>[];

  @override
  void initState() {
    getAllMesajAndDoktorByHastaNoFromApi(widget.hasta.hastaNo);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mesajlar"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: hastaMesajList.length,
        itemBuilder: (context, int index) {
          var messageDoctor = doktorList.firstWhere(
              (element) => element.doktorNo == hastaMesajList[index].doktorNo);
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageScreen(
                    hasta: widget.hasta,
                    doktor: messageDoctor,
                    mesaj: hastaMesajList[index],
                    permSendMessage: false,
                  ),
                ),
              );
            },
            title: Text("${messageDoctor.ad} ${messageDoctor.soyad}"),
            subtitle: Row(
              children: [
                Flexible(
                  child: Text(
                    hastaMesajList[index].doktorYanit == null
                        ? hastaMesajList[index].hastaMesaj
                        : hastaMesajList[index].doktorYanit!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            leading: CircleAvatar(
              child: SvgPicture.asset(messageDoctor.cinsiyet
                  ? "assets/images/person-girl-flat.svg"
                  : "assets/images/person-flat.svg"),
            ),
            trailing: const Icon(Icons.zoom_in),
          );
        },
      ),
    );
  }

  getAllMesajAndDoktorByHastaNoFromApi(int hastaNo) {
    hastaMesajList.clear();
    doktorList.clear();
    MesajApi.getAllByHastaNo(hastaNo).then((response) {
      ApiGetResponse apiResponse =
          ApiGetResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        for (int i = 0; i < apiResponse.data.length; i++) {
          var message = Mesaj.fromJson(apiResponse.data[i]);
          if (doktorList
              .any((element) => element.doktorNo == message.doktorNo)) {
            setState(() {
              if (!hastaMesajList.contains(message)) {
                hastaMesajList.add(message);
              }
            });
          } else {
            DoktorApi.getByDoktorNo(message.doktorNo).then((response2) {
              var apiResponse2 =
                  ApiGetResponse.fromJson(json.decode(response2.body));
              if (apiResponse2.success) {
                var doktor = Doktor.fromJson(apiResponse2.data[0]);
                setState(() {
                  if (!hastaMesajList.contains(message)) {
                    hastaMesajList.add(message);
                  }
                  if (!doktorList.contains(doktor)) {
                    doktorList.add(doktor);
                  }
                });
              }
            });
          }
        }
      }
    });
  }
}
