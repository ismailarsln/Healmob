import 'dart:convert';

import 'package:healmob/environment.dart';
import 'package:healmob/models/doktor.dart';
import 'package:http/http.dart' as http;

const route = Environment.APIURL + "doktor";

class DoktorApi {
  static Future getAll() {
    return http.get(Uri.parse(route + "/getall"));
  }

  static Future getByDoktorNo(int doktorNo) {
    return http.get(Uri.parse(route + "/getbydoktorno/$doktorNo"));
  }

  static Future getAllByAnabilimDaliNo(int anabilimDaliNo) {
    return http.get(Uri.parse(route + "/getbyanabilimdalino/$anabilimDaliNo"));
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

  static Future add(Doktor doktor) {
    return http.post(Uri.parse(route + "/add"),
        headers: Environment.APIHEADERS, body: json.encode(doktor));
  }

  static Future delete(Doktor doktor) {
    return http.post(Uri.parse(route + "/delete"),
        headers: Environment.APIHEADERS, body: json.encode(doktor));
  }

  static Future update(Doktor doktor) {
    return http.post(Uri.parse(route + "/update"),
        headers: Environment.APIHEADERS, body: json.encode(doktor));
  }
}
