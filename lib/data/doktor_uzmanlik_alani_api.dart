import 'package:healmob/environment.dart';
import 'package:healmob/models/doktor_uzmanlik_alani.dart';
import 'package:http/http.dart' as http;

const route = Environment.APIURL + "doktoruzmanlikalani";

class DoktorUzmanlikAlaniApi {
  static Future getAll() {
    return http.get(Uri.parse(route + "/getall"));
  }

  static Future getAllByDoktorNo(int doktorNo) {
    return http.get(Uri.parse(route + "/getallbydoktorno/$doktorNo"));
  }

  static Future getAllByUzmanlikAlaniId(int uzmanlikAlaniId) {
    return http
        .get(Uri.parse(route + "/getallbyuzmanlikalaniid/$uzmanlikAlaniId"));
  }

  static Future getById(int id) {
    return http.get(Uri.parse(route + "/getbyid/$id"));
  }

  static Future add(DoktorUzmanlikAlani doktorUzmanlikAlani) {
    return http.post(Uri.parse(route + "/add"),
        headers: Environment.APIHEADERS, body: doktorUzmanlikAlani.toJson());
  }

  static Future delete(DoktorUzmanlikAlani doktorUzmanlikAlani) {
    return http.post(Uri.parse(route + "/delete"),
        headers: Environment.APIHEADERS, body: doktorUzmanlikAlani.toJson());
  }

  static Future update(DoktorUzmanlikAlani doktorUzmanlikAlani) {
    return http.post(Uri.parse(route + "/update"),
        headers: Environment.APIHEADERS, body: doktorUzmanlikAlani.toJson());
  }
}
