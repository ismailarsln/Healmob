class Doktor {
  final int doktorNo;
  final int anabilimDaliNo;
  final String email;
  final String sifre;
  final String ad;
  final String soyad;
  final String telefon;
  final bool cinsiyet;
  final bool aktifDurum;
  final String? resimYolu;

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
        cinsiyet = json["cinsiyet"],
        aktifDurum = json["aktif_durum"],
        resimYolu = json["resim_yolu"];

  Map toJson() {
    return {
      "doktor_no": doktorNo,
      "anabilim_dali_no": anabilimDaliNo,
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
