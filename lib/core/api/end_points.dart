class EndPoints {
  static const String baseUrl = "https://693d11fdf58.mockapi.io/quote";

  ///////////////////////  Auth ///////////////////////////////////////////
  static const String refreshToken = "$baseUrl/api/auth/refresh";
  static const String login = "$baseUrl/api/auth/login";
  static const String logout = "$baseUrl/api/auth/logout";

  //////////////////////////// Face ////////////////////////////////////////
  static const String enrollFace = "$baseUrl/api/face/enroll";
}
