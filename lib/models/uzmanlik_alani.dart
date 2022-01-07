class UzmanlikAlani {
  final int uzmanlikAlaniId;
  final String uzmanlikAlaniAdi;

  UzmanlikAlani(this.uzmanlikAlaniId, this.uzmanlikAlaniAdi);

  UzmanlikAlani.fromJson(Map json)
      : uzmanlikAlaniId = int.tryParse(json["uzmanlik_alani_id"].toString())!,
        uzmanlikAlaniAdi = json["uzmanlik_alani_adi"];

  Map toJson() {
    return {
      "uzmanlik_alani_id": uzmanlikAlaniId,
      "uzmanlik_alani_adi": uzmanlikAlaniAdi
    };
  }
}
