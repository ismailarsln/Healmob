import 'package:healmob/models/api_response/post_upload_model.dart';

class ApiUploadPostResponse {
  final PostUploadModel data;
  final bool success;
  final String message;
  final String status;

  ApiUploadPostResponse(this.data, this.success, this.message, this.status);

  ApiUploadPostResponse.fromJson(Map json)
      : data = PostUploadModel.fromJson(json["data"]),
        success = json["success"],
        message = json["message"],
        status = json["status"];

  Map toJson() {
    return {
      "data": data,
      "success": success,
      "message": message,
      "status": status
    };
  }
}
