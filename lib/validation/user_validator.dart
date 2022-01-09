import 'package:email_validator/email_validator.dart';

class UserValidationMixin {
  String? validateFirstName(String? value) {
    if (value!.length < 3) {
      return "Ad en az 3 karakter olmalıdır";
    }
  }

  String? validateLastName(String? value) {
    if (value!.length < 3) {
      return "Soyad en az 3 karakter olmalıdır";
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
      return "Geçersiz e-posta adresi";
    }
  }

  String? validatePassword(String? value) {
    if (value!.length < 6) {
      return "Şifre en az 6 karakter olmalıdır";
    }
  }

  //https://stackoverflow.com/questions/57488141/how-to-check-entered-phone-number-is-valid-or-not-with-flutter
  String? validatePhone(String? value) {
    if (value!.length < 10 || RegExp('[a-zA-Z]').hasMatch(value)) {
      return "Geçersiz telefon numarası";
    }
  }
}
