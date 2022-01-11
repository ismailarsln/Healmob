class PostUploadModel {
  final String path;

  PostUploadModel(this.path);

  PostUploadModel.fromJson(Map json) : path = (json["path"]);

  Map toJson() {
    return {
      "path": path,
    };
  }
}
