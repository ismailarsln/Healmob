import 'package:healmob/models/api_response/post_data_model.dart';

class ApiPostResponse {
  final PostDataModel data;
  final bool success;
  final String message;
  final String status;

  ApiPostResponse(this.data, this.success, this.message, this.status);

  ApiPostResponse.fromJson(Map json)
      : data = PostDataModel.fromJson(json["data"]),
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
