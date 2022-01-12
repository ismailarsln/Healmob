class Doktor {
  int doktorNo;
  int anabilimDaliNo;
  String email;
  String sifre;
  String ad;
  String soyad;
  String telefon;
  bool cinsiyet;
  bool aktifDurum;
  String? resimYolu;

  Doktor(this.doktorNo, this.anabilimDaliNo, this.email, this.sifre, this.ad,
      this.soyad, this.telefon, this.cinsiyet, this.aktifDurum, this.resimYolu);

  Doktor.fromJson(Map json)
      : doktorNo = int.tryParse(json["doktor_no"].toString())!,
        anabilimDaliNo = int.tryParse(json["anabilim_dali_no"].toString())!,
        email = json["email"],
        sifre = json["sifre"],
        ad = json["ad"],
        soyad = json["soyad"],
        telefon = json["telefon"],
        cinsiyet = json["cinsiyet"] == 0 ? false : true,
        aktifDurum = json["aktif_durum"] == 0 ? false : true,
        resimYolu = json["resim_yolu"] == "null" ? null : json["resim_yolu"];

  Map toJson() {
    return {
      "doktor_no": doktorNo,
      "anabilim_dali_no": anabilimDaliNo,
      "email": email,
      "sifre": sifre,
      "ad": ad,
      "soyad": soyad,
      "telefon": telefon,
      "cinsiyet": cinsiyet ? 1 : 0,
      "aktif_durum": aktifDurum ? 1 : 0,
      "resim_yolu": resimYolu ?? "",
    };
  }
}
