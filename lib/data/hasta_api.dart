import 'dart:convert';

import 'package:healmob/environment.dart';
import 'package:healmob/models/hasta.dart';
import 'package:http/http.dart' as http;

const route = Environment.APIURL + "hasta";

class HastaApi {
  static Future getAll() {
    return http.get(Uri.parse(route + "/getall"));
  }

  static Future getByHastaNo(int hastaNo) {
    return http.get(Uri.parse(route + "/getbyhastano/$hastaNo"));
  }

  static Future getAllByEmail(String email) {
    return http.get(Uri.parse(route + "/getbyemail/$email"));
  }

  static Future getAllByName(String name) {
    return http.get(Uri.parse(route + "/getbyname/$name"));
  }

  static Future getAllBySurname(String surname) {
    return http.get(Uri.parse(route + "/getbyname/$surname"));
  }

  static Future getAllByCinsiyet(int cinsiyet) {
    return http.get(Uri.parse(route + "/getbycinsiyet/$cinsiyet"));
  }

  static Future getAllByAktifDurum(int aktifDurum) {
    return http.get(Uri.parse(route + "/getbyaktifdurum/$aktifDurum"));
  }

  static Future add(Hasta hasta) {
    return http.post(Uri.parse(route + "/add"),
        headers: Environment.APIHEADERS, body: json.encode(hasta));
  }

  static Future delete(Hasta hasta) {
    return http.post(Uri.parse(route + "/delete"),
        headers: Environment.APIHEADERS, body: json.encode(hasta));
  }

  static Future update(Hasta hasta) {
    return http.post(Uri.parse(route + "/update"),
        headers: Environment.APIHEADERS, body: json.encode(hasta));
  }
}
