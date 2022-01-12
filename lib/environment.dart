//https://stacksecrets.com/flutter/environment-configuration-in-flutter-app
class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String APIURL = "http://10.0.2.2:3000/";
  static const Map<String, String> APIHEADERS = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String FBSERVERKEY = "YOUR_SERVER_KEY";
}
