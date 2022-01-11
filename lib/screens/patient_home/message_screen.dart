import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/mesaj_api.dart';
import 'package:healmob/models/api_response/api_get_response.dart';
import 'package:healmob/models/api_response/api_post_response.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/models/hasta.dart';
import 'package:healmob/models/mesaj.dart';

class MessageScreen extends StatefulWidget {
  Hasta hasta;
  Doktor doktor;
  Mesaj mesaj;
  bool permSendMessage;

  MessageScreen(
      {Key? key,
      required this.mesaj,
      required this.hasta,
      required this.doktor,
      required this.permSendMessage})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController txtMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: SvgPicture.asset(widget.doktor.cinsiyet
                  ? "assets/images/person-girl-flat.svg"
                  : "assets/images/person-flat.svg"),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text("${widget.doktor.ad} ${widget.doktor.soyad}"),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    showMessage(true, widget.mesaj.hastaMesaj),
                    const SizedBox(
                      height: 50.0,
                    ),
                    showMessage(false, widget.mesaj.doktorYanit),
                  ],
                ),
              ),
            ),
          ),
          if (widget.permSendMessage) buildMessageComposer(),
        ],
      ),
    );
  }

  Widget showMessage(bool isSender, String? message) {
    if (message == null || message == "") {
      return const Text("");
    }
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender)
          CircleAvatar(
            radius: 15,
            child: SvgPicture.asset(widget.doktor.cinsiyet
                ? "assets/images/person-girl-flat.svg"
                : "assets/images/person-flat.svg"),
          ),
        Flexible(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                  color: isSender ? appPrimaryColor : Colors.green,
                  borderRadius: BorderRadius.circular(30.0)),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              )),
        ),
        if (isSender)
          CircleAvatar(
            radius: 15,
            child: SvgPicture.asset(widget.hasta.cinsiyet
                ? "assets/images/person-girl-flat.svg"
                : "assets/images/person-flat.svg"),
          ),
      ],
    );
  }

  //https://www.freecodecamp.org/news/build-a-chat-app-ui-with-flutter/
  buildMessageComposer() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: appPrimaryColor,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: appPrimaryColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        txtMessage.text = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Mesaj yaz...",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${txtMessage.text.length}/6000",
                  style: const TextStyle(color: Colors.white54),
                ),
                FloatingActionButton(
                  onPressed: () {
                    if (txtMessage.text.isNotEmpty) {
                      if (txtMessage.text.length > 6000) {
                        _showAlert(context, "Karakter sınırı aşıldı",
                            "Mesajınız 6000 karakteri geçemez");
                        return;
                      }
                      var message = Mesaj(1, widget.hasta.hastaNo,
                          widget.doktor.doktorNo, txtMessage.text, "", "");
                      MesajApi.sendMessage(message).then((response) {
                        var apiResponse = ApiPostResponse.fromJson(
                            json.decode(response.body));
                        if (apiResponse.success) {
                          MesajApi.getById(apiResponse.data.insertId).then(
                            (getResponse) {
                              var apiGetResponse = ApiGetResponse.fromJson(
                                  json.decode(getResponse.body));
                              if (apiGetResponse.success) {
                                var newMessage =
                                    Mesaj.fromJson(apiGetResponse.data[0]);
                                setState(
                                  () {
                                    widget.mesaj = newMessage;
                                    widget.permSendMessage = false;
                                    txtMessage.clear();
                                  },
                                );
                              } else {
                                _showAlert(context, "Mesaj gönderildi",
                                    "Mesaj gönderildi ancak sunucudan doğrulanamadı. Uygulamayı yeniden başlatabilirsiniz");
                                return;
                              }
                            },
                          );
                        } else {
                          _showAlert(context, "Mesaj gönderilemedi",
                              "Mesaj gönderilirken bir sorun oluştu\n\n${apiResponse.message}");
                        }
                      });
                    }
                  },
                  child: const Icon(
                    Icons.send,
                    color: appPrimaryColor,
                    size: 20,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
      ],
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
