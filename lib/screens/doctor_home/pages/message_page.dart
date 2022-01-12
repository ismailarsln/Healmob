import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/hasta_api.dart';
import 'package:healmob/data/mesaj_api.dart';
import 'package:healmob/environment.dart';
import 'package:healmob/models/api_response/api_get_response.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/models/hasta.dart';
import 'package:healmob/models/mesaj.dart';
import 'package:healmob/screens/doctor_home/message_screen.dart';

class MessagePage extends StatefulWidget {
  final Doktor doktor;
  const MessagePage({Key? key, required this.doktor}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Mesaj> mesajList = <Mesaj>[];
  List<Hasta> hastaList = <Hasta>[];
  @override
  void initState() {
    getAllMesajAnHastaByHastaNoFromApi(widget.doktor.doktorNo);
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
        itemCount: mesajList.length,
        itemBuilder: (context, int index) {
          var messageHasta = hastaList.firstWhere(
              (element) => element.hastaNo == mesajList[index].hastaNo);
          return ListTile(
            tileColor: mesajList[index].doktorYanit == null
                ? const Color(0xFFFACBCB)
                : Colors.transparent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageScreen(
                    hasta: messageHasta,
                    doktor: widget.doktor,
                    mesaj: mesajList[index],
                    permSendMessage: mesajList[index].doktorYanit == null,
                  ),
                ),
              );
            },
            title: Text("${messageHasta.ad} ${messageHasta.soyad}"),
            subtitle: Row(
              children: [
                Flexible(
                  child: Text(
                    mesajList[index].doktorYanit == null
                        ? mesajList[index].hastaMesaj
                        : mesajList[index].doktorYanit!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            leading: CircleAvatar(
              backgroundColor:
                  messageHasta.aktifDurum ? Colors.green : Colors.red,
              radius: 27,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 18,
                backgroundColor: Colors.transparent,
                child: messageHasta.resimYolu == "" ||
                        messageHasta.resimYolu == null
                    ? ClipOval(
                        child: SvgPicture.asset(
                          messageHasta.cinsiyet
                              ? "assets/images/person-girl-flat.svg"
                              : "assets/images/person-flat.svg",
                        ),
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              "${Environment.APIURL}/${messageHasta.resimYolu}",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            size: 40,
                          ),
                        ),
                      ),
              ),
            ),
            trailing: mesajList[index].doktorYanit == null
                ? const Icon(
                    Icons.send,
                    color: appPrimaryDarkColor,
                  )
                : const Icon(
                    Icons.done,
                    color: Colors.green,
                  ),
          );
        },
      ),
    );
  }

  getAllMesajAnHastaByHastaNoFromApi(int doktorNo) {
    mesajList.clear();
    hastaList.clear();
    MesajApi.getAllByDoktorNo(doktorNo).then((response) {
      ApiGetResponse apiResponse =
          ApiGetResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        for (int i = 0; i < apiResponse.data.length; i++) {
          var message = Mesaj.fromJson(apiResponse.data[i]);
          if (hastaList.any((element) => element.hastaNo == message.hastaNo)) {
            setState(() {
              if (!mesajList.contains(message)) {
                mesajList.add(message);
                mesajList.sort(
                  (a, b) => b.gonderimTarihi.compareTo(a.gonderimTarihi),
                );
              }
            });
          } else {
            HastaApi.getByHastaNo(message.hastaNo).then((response2) {
              var apiResponse2 =
                  ApiGetResponse.fromJson(json.decode(response2.body));
              if (apiResponse2.success) {
                var hasta = Hasta.fromJson(apiResponse2.data[0]);
                setState(() {
                  if (!mesajList.contains(message)) {
                    mesajList.add(message);
                    mesajList.sort(
                        (a, b) => b.gonderimTarihi.compareTo(a.gonderimTarihi));
                  }
                  if (!hastaList.contains(hasta)) {
                    hastaList.add(hasta);
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
