import 'package:healmob/environment.dart';
import 'package:healmob/models/uzmanlik_alani.dart';
import 'package:http/http.dart' as http;

const route = Environment.APIURL + "/uzmanlikalani";

class UzmanlikAlaniApi {
  static Future getAll() {
    return http.get(Uri.parse(route + "/getall"));
  }

  static Future getById(int id) {
    return http.get(Uri.parse(route + "/getbyid/$id"));
  }

  static Future getAllByUzmanlikAlaniAdi(String uzmanlikAlaniAdi) {
    return http.get(Uri.parse(route + "/getbyname/$uzmanlikAlaniAdi"));
  }

  static Future add(UzmanlikAlani uzmanlikAlani) {
    return http.post(Uri.parse(route + "/add"),
        headers: Environment.APIHEADERS, body: uzmanlikAlani.toJson());
  }

  static Future delete(UzmanlikAlani uzmanlikAlani) {
    return http.post(Uri.parse(route + "/delete"),
        headers: Environment.APIHEADERS, body: uzmanlikAlani.toJson());
  }

  static Future update(UzmanlikAlani uzmanlikAlani) {
    return http.post(Uri.parse(route + "/update"),
        headers: Environment.APIHEADERS, body: uzmanlikAlani.toJson());
  }
}
