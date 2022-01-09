import 'package:healmob/environment.dart';
import 'package:healmob/models/anabilim_dali.dart';
import 'package:http/http.dart' as http;

const route = Environment.APIURL + "anabilimdali";

class AnabilimDaliApi {
  static Future getAll() {
    return http.get(Uri.parse(route + "/getall"));
  }

  static Future getAllByAnabilimDaliNo(int anabilimdDaliNo) {
    return http.get(Uri.parse(route + "/getbyanabilimdalino/$anabilimdDaliNo"));
  }

  static Future getAllByName(String name) {
    return http.get(Uri.parse(route + "/getbyname/$name"));
  }

  static Future add(AnabilimDali anabilimDali) {
    return http.post(Uri.parse(route + "/add"),
        headers: Environment.APIHEADERS, body: anabilimDali.toJson());
  }

  static Future delete(AnabilimDali anabilimDali) {
    return http.post(Uri.parse(route + "/delete"),
        headers: Environment.APIHEADERS, body: anabilimDali.toJson());
  }

  static Future update(AnabilimDali anabilimDali) {
    return http.post(Uri.parse(route + "/update"),
        headers: Environment.APIHEADERS, body: anabilimDali.toJson());
  }
}
