class AnabilimDali {
  final int anabilimDaliNo;
  final String anabilimDaliAdi;

  AnabilimDali(this.anabilimDaliNo, this.anabilimDaliAdi);

  AnabilimDali.fromJson(Map json)
      : anabilimDaliNo = int.tryParse(json["anabilim_dali_no"].toString())!,
        anabilimDaliAdi = json["anabilim_dali_adi"];

  Map toJson() {
    return {
      "anabilim_dali_no": anabilimDaliNo,
      "anabilim_dali_adi": anabilimDaliAdi
    };
  }
}
