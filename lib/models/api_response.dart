class ApiResponse {
  final List data;
  final bool success;
  final String message;
  final String status;

  ApiResponse(this.data, this.success, this.message, this.status);

  ApiResponse.fromJson(Map json)
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
