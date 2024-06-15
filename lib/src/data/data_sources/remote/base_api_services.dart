abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, Map<String, dynamic> dic);
  Future<dynamic> getPostUploadMultiPartApiResponse(
      String url,
      Map<String, String> dic,
      dynamic fileBytes,
      String fileName,
      String uploadFileKeyName,
      String sessionToken);

     Future<dynamic>  getPostDownloadZip(String url, Map<String, dynamic> dic);
}
