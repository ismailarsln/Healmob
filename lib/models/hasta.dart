class Hasta {
  int hastaNo;
  String email;
  String sifre;
  String ad;
  String soyad;
  String telefon;
  bool cinsiyet;
  bool aktifDurum;
  String? resimYolu;

  Hasta(this.hastaNo, this.email, this.sifre, this.ad, this.soyad, this.telefon,
      this.cinsiyet, this.aktifDurum, this.resimYolu);

  Hasta.fromJson(Map json)
      : hastaNo = int.tryParse(json["hasta_no"].toString())!,
        email = json["email"],
        sifre = json["sifre"],
        ad = json["ad"],
        soyad = json["soyad"],
        telefon = json["telefon"],
        cinsiyet = json["cinsiyet"],
        aktifDurum = json["aktif_durum"],
        resimYolu = json["resim_yolu"];

  Map toJson() {
    return {
      "hasta_no": hastaNo,
      "email": email,
      "sifre": sifre,
      "ad": ad,
      "soyad": soyad,
      "telefon": telefon,
      "cinsiyet": cinsiyet,
      "aktif_durum": aktifDurum,
      "resim_yolu": resimYolu
    };
  }
}
