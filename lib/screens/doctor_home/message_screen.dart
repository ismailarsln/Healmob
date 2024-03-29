import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/mesaj_api.dart';
import 'package:healmob/data/notification_service.dart';
import 'package:healmob/environment.dart';
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
              backgroundColor:
                  widget.hasta.aktifDurum ? Colors.green : Colors.red,
              radius: 23,
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 20,
                backgroundColor: Colors.transparent,
                child: widget.hasta.resimYolu == "" ||
                        widget.hasta.resimYolu == null
                    ? ClipOval(
                        child: SvgPicture.asset(
                          widget.hasta.cinsiyet
                              ? "assets/images/person-girl-flat.svg"
                              : "assets/images/person-flat.svg",
                        ),
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              "${Environment.APIURL}/${widget.hasta.resimYolu}",
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
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Text("${widget.hasta.ad} ${widget.hasta.soyad}"),
            ),
          ],
        ),
        actions: widget.permSendMessage
            ? []
            : [
                IconButton(
                  onPressed: () {
                    var cancelButton = TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("İptal"));
                    var deleteButton = TextButton(
                        onPressed: () {
                          MesajApi.delete(widget.mesaj).then((response) {
                            var apiResponse = ApiPostResponse.fromJson(
                                json.decode(response.body));
                            if (apiResponse.success) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  "/doctorHome", ModalRoute.withName('/'),
                                  arguments: widget.doktor);
                            } else {
                              _showAlert(context, "Silme başarısız",
                                  "Mesajı silerken bir şeyler ters gitti\n\n${apiResponse.message}");
                              Navigator.pop(context);
                              return;
                            }
                          });
                        },
                        child: const Text("Sil"));
                    var alert = AlertDialog(
                      title: const Text("Silme onayı"),
                      content: const Text(
                          "Bu mesajı silmek istediğinize emin misiniz?"),
                      actions: [deleteButton, cancelButton],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                const SizedBox(
                  width: 10,
                )
              ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    showMessage(false, widget.mesaj.hastaMesaj,
                        (widget.mesaj.gonderimTarihi.toString().split(".")[0])),
                    const SizedBox(
                      height: 50.0,
                    ),
                    showMessage(
                        true,
                        widget.mesaj.doktorYanit,
                        (widget.mesaj.yanitlanmaTarihi
                            .toString()
                            .split(".")[0])),
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

  Widget showMessage(bool isSender, String? message, String sendTime) {
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
            radius: MediaQuery.of(context).size.width / 18,
            backgroundColor: Colors.transparent,
            child:
                widget.hasta.resimYolu == "" || widget.hasta.resimYolu == null
                    ? ClipOval(
                        child: SvgPicture.asset(
                          widget.hasta.cinsiyet
                              ? "assets/images/person-girl-flat.svg"
                              : "assets/images/person-flat.svg",
                        ),
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              "${Environment.APIURL}/${widget.hasta.resimYolu}",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            size: 40,
                          ),
                        ),
                      ),
          ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
                color: isSender ? appPrimaryColor : Colors.green,
                borderRadius: BorderRadius.circular(30.0)),
            child: Column(
              crossAxisAlignment:
                  isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  sendTime,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                )
              ],
            ),
          ),
        ),
        if (isSender)
          CircleAvatar(
            radius: MediaQuery.of(context).size.width / 18,
            backgroundColor: Colors.transparent,
            child:
                widget.doktor.resimYolu == "" || widget.doktor.resimYolu == null
                    ? ClipOval(
                        child: SvgPicture.asset(
                          widget.doktor.cinsiyet
                              ? "assets/images/person-girl-flat.svg"
                              : "assets/images/person-flat.svg",
                        ),
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              "${Environment.APIURL}/${widget.doktor.resimYolu}",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            size: 40,
                          ),
                        ),
                      ),
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
                      var message = Mesaj(
                          widget.mesaj.mesajId,
                          widget.mesaj.hastaNo,
                          widget.mesaj.doktorNo,
                          widget.mesaj.hastaMesaj,
                          txtMessage.text,
                          widget.mesaj.hastaEkYolu,
                          widget.mesaj.gonderimTarihi,
                          DateTime.now());
                      MesajApi.replyToMessage(message).then((response) {
                        var apiResponse = ApiPostResponse.fromJson(
                            json.decode(response.body));
                        if (apiResponse.success &&
                            apiResponse.data.affectedRows == 1) {
                          MesajApi.getById(widget.mesaj.mesajId).then(
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
                                    NotificationApi.sendNotification(
                                        "${widget.hasta.hastaNo}_${widget.hasta.email.replaceAll("@", "_")}",
                                        "Doktordan mesajınız var",
                                        "Doktor ${widget.doktor.ad.replaceFirst(widget.doktor.ad[0], widget.doktor.ad[0].toUpperCase())} ${widget.doktor.soyad.replaceFirst(widget.doktor.soyad[0], widget.doktor.soyad[0].toUpperCase())} mesajınıza yanıt verdi");
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
