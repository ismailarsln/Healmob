class DoktorUzmanlikAlani {
  final int id;
  final int doktorNo;
  final int uzmanlikAlaniId;

  DoktorUzmanlikAlani(this.id, this.doktorNo, this.uzmanlikAlaniId);

  DoktorUzmanlikAlani.fromJson(Map json)
      : id = int.tryParse(json["id"].toString())!,
        doktorNo = int.tryParse(json["doktor_no"].toString())!,
        uzmanlikAlaniId = int.tryParse(json["uzmanlik_alani_id"].toString())!;

  Map toJson() {
    return {
      "id": id,
      "doktor_no": doktorNo,
      "uzmanlik_alani_id": uzmanlikAlaniId
    };
  }
}
