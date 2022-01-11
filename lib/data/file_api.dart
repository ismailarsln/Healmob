import 'package:file_picker/file_picker.dart';
import 'package:healmob/environment.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

const route = Environment.APIURL + "files";

class FileApi {
  static Future getByPath(String path) {
    return http.get(Uri.parse(Environment.APIURL + path));
  }

  static Future uploadImage(PlatformFile file) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(route + "/imageupload"));
    request.files.add(http.MultipartFile('file', file.readStream!, file.size,
        filename: file.name,
        contentType: MediaType.parse(lookupMimeType(file.path!)!)));
    return request.send();
  }
}
