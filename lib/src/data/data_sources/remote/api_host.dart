class ApiURL {
  final String hosturl;

  ApiURL._(this.hosturl);

  factory ApiURL.devENV() {
    return ApiURL._('https://api.slingacademy.com/v1/sample-data');
  }

  factory ApiURL.prodENV() {
    return ApiURL._('https://api.slingacademy.com/v1/sample-data');
  }

  // uat
  static const String baseURL = 'https://api.slingacademy.com/v1/sample-data';
  static const String getUserPoint = '$baseURL/users';

  //prod
}
