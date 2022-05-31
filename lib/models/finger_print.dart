class FingerPrintAuth {
  bool? isEntered;
  String? email;

  FingerPrintAuth(
    this.isEntered,
    this.email,
  );

  FingerPrintAuth.fromJson(Map json) {
    isEntered = json["isEntered"];
    email = json["email"].toString();
  }

  Map toJson() {
    return {
      "isEntered": isEntered,
      "email": email,
    };
  }
}
