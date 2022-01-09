import 'package:healmob/environment.dart';
import 'package:healmob/models/mesaj.dart';
import 'package:http/http.dart' as http;

const route = Environment.APIURL + "mesaj";

class MesajApi {
  static Future getAll() {
    return http.get(Uri.parse(route + "/getall"));
  }

  static Future getById(int id) {
    return http.get(Uri.parse(route + "/getbyid/$id"));
  }

  static Future getAllByHastaNo(int hastaNo) {
    return http.get(Uri.parse(route + "/getallbyhastano/$hastaNo"));
  }

  static Future getAllByDoktorNo(int doktorNo) {
    return http.get(Uri.parse(route + "/getallbydoktorno/$doktorNo"));
  }

  static Future sendMessage(Mesaj mesaj) {
    return http.post(Uri.parse(route + "/sendmessage"),
        headers: Environment.APIHEADERS, body: mesaj.toJson());
  }

  static Future delete(Mesaj mesaj) {
    return http.post(Uri.parse(route + "/delete"),
        headers: Environment.APIHEADERS, body: mesaj.toJson());
  }

  static Future replyToMessage(Mesaj mesaj) {
    return http.post(Uri.parse(route + "/replytomessage"),
        headers: Environment.APIHEADERS, body: mesaj.toJson());
  }
}
