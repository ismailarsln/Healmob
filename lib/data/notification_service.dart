import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:healmob/environment.dart';
import 'package:http/http.dart' as http;

const route = Environment.APIURL + "fcm";

class NotificationApi {
  static Future sendNotification(
      String topicName, String title, String body) async {
    var requestBody = {
      "topic_name": topicName,
      "body_text": body,
      "title_text": title
    };
    return http.post(Uri.parse(route + "/sendmessage"),
        headers: Environment.APIHEADERS, body: json.encode(requestBody));
  }

  static Future unSubscribeAllTopicsWithoutOneKey(
      String token, String withoutKey) async {
    var reqHeader = <String, String>{
      "Authorization": "key=${Environment.FCMSERVERKEY}",
      "Content-Type": "application/json",
    };
    var params = "$token?details=true";

    var response = await http.get(
        Uri.parse("https://iid.googleapis.com/iid/info/$params"),
        headers: reqHeader);
    var result = await json.decode(response.body);
    if (result != null &&
        result["rel"] != null &&
        result["rel"]["topics"] != null) {
      List keyList = result["rel"]["topics"].keys.toList();
      for (var key in keyList) {
        if (key != withoutKey) {
          FirebaseMessaging.instance.unsubscribeFromTopic(key);
        }
      }
    }
  }
}
