class Mesaj {
  final int mesajId;
  final int hastaNo;
  final int doktorNo;
  final String hastaMesaj;
  final String? doktorYanit;
  final String? hastaEkYolu;
  final DateTime gonderimTarihi;
  final DateTime? yanitlanmaTarihi;

  Mesaj(
      this.mesajId,
      this.hastaNo,
      this.doktorNo,
      this.hastaMesaj,
      this.doktorYanit,
      this.hastaEkYolu,
      this.gonderimTarihi,
      this.yanitlanmaTarihi);

  Mesaj.fromJson(Map json)
      : mesajId = int.tryParse(json["mesaj_id"].toString())!,
        hastaNo = int.tryParse(json["hasta_no"].toString())!,
        doktorNo = int.tryParse(json["doktor_no"].toString())!,
        hastaMesaj = json["hasta_mesaj"],
        doktorYanit = json["doktor_yanit"],
        hastaEkYolu = json["hasta_ek_yolu"],
        gonderimTarihi = DateTime.parse(json["gonderim_tarihi"]),
        yanitlanmaTarihi = json["yanitlanma_tarihi"] == null
            ? null
            : DateTime.parse(json["yanitlanma_tarihi"]);

  Map toJson() {
    return {
      "mesaj_id": mesajId,
      "hasta_no": hastaNo,
      "doktor_no": doktorNo,
      "hasta_mesaj": hastaMesaj,
      "doktor_yanit": doktorYanit,
      "hasta_ek_yolu": hastaEkYolu,
      "gonderim_tarihi": gonderimTarihi.toString(),
      "yanitlanma_tarihi": yanitlanmaTarihi.toString()
    };
  }
}
