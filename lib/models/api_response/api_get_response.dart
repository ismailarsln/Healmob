class ApiGetResponse {
  final List data;
  final bool success;
  final String message;
  final String status;

  ApiGetResponse(this.data, this.success, this.message, this.status);

  ApiGetResponse.fromJson(Map json)
      : data = json["data"],
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
