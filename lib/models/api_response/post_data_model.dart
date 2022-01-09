class PostDataModel {
  // {"affectedRows":1,"insertId":25,"changedRows":0}
  // {"affectedRows":-1,"insertId":-1,"changedRows":-1}
  final int affectedRows;
  final int insertId;
  final int changedRows;

  PostDataModel(this.affectedRows, this.insertId, this.changedRows);

  PostDataModel.fromJson(Map json)
      : affectedRows = int.tryParse(json["affectedRows"].toString())!,
        insertId = int.tryParse(json["insertId"].toString())!,
        changedRows = int.tryParse(json["changedRows"].toString())!;

  Map toJson() {
    return {
      "affectedRows": affectedRows,
      "insertId": insertId,
      "changedRows": changedRows
    };
  }
}
