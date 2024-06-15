import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'remote.dart';

class NetworkApiService implements BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(const Duration(seconds: 60));
      responseJson = returnResponse(response,false,'',url);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print(url);      
    }
    dynamic responseJson;
    try {
      Response response =
          await http.post(Uri.parse(url), body: jsonEncode(dic), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(const Duration(seconds: 60));

      responseJson = returnResponse(response,false,dic.containsKey('sessionToken')? dic['sessionToken']:'',url);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      _catchException(dic['sessionToken'], 'Network Request time out \n\n$url',);
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

@override
  Future getPostDownloadZip(String url, Map<String, dynamic> dic) async {
    if (kDebugMode) {
      print(url);      
    }
    dynamic responseJson;
    try {

      Response response =
          await http.post(Uri.parse(url), body: jsonEncode(dic), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(const Duration(seconds: 60));

      responseJson = returnResponse(response,true,dic.containsKey('sessionToken')?dic['sessionToken']:'',url);
      // final request = http.MultipartRequest('POST', Uri.parse(url));
      // if (fileBytes != null && fileBytes.isNotEmpty) {
      //   request.files.add(
      //     await http.MultipartFile.fromBytes(
      //       uploadFileKeyName,//'bulkShipmentsCsv'
      //       fileBytes ?? [],
      //       filename: fileName.isEmpty ? 'bulkShipmentsCsv' : fileName,
      //     ),
      //   );
      // }
      // request.fields.addAll(dic);//{'sessionToken': sessionToken}
      // final http.Response response =
      //     await http.Response.fromStream(await request.send())
      //         .timeout(const Duration(seconds: 60));
      // responseJson = returnResponse(response,true);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }


  @override
  Future getPostUploadMultiPartApiResponse(
      String url,
      Map<String, String> dic,
      dynamic fileBytes,
      String fileName,
      String uploadFileKeyName,
      String sessionToken) async {
    if (kDebugMode) {
      print(url);      
    }
    dynamic responseJson;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      if (fileBytes != null && fileBytes.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromBytes(
            uploadFileKeyName,//'bulkShipmentsCsv'
            fileBytes ?? [],
            filename: fileName.isEmpty ? 'bulkShipmentsCsv' : fileName,
          ),
        );
      }
      request.fields.addAll(dic);//{'sessionToken': sessionToken}
      final http.Response response =
          await http.Response.fromStream(await request.send())
              .timeout(const Duration(seconds: 60));
      responseJson = returnResponse(response,true,sessionToken,url);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response,bool isMultipart,String sessionToken,String url) {
    if (kDebugMode) {
      print(response.statusCode);
    }

    switch (response.statusCode) {
      case 200:
        final dynamic responseJson =isMultipart? response:jsonDecode(response.body);
        return responseJson;
      case 400:        
        _catchException(sessionToken, 'Invalid request : ${response.body.toString()} \n\n$url');
        throw BadRequestException(response.body.toString());
      case 500:
        _catchException(sessionToken, 'Error Code: 500 : ${response.body.toString()} \n\n$url');
      case 404:
        _catchException(sessionToken, 'Error Code: 404 :Unauthorised request ${response.body.toString()} \n\n$url');
        throw UnauthorisedException(response.body.toString());
      default:
        _catchException(sessionToken, 'Error occured while communicating with server [${response.body.toString()}] \n\n$url');
        throw FetchDataException(
            'Error occured while communicating with server');
    }
  }

Future _catchException(String sessionToken,String reason)async
{
  // if(sessionToken.isNotEmpty)
  // {
  // BalanceRepository apiServices=ExceptionHttpApiRepository();
  //      await apiServices.exception({
  //               "sessionToken":sessionToken,
  //               "message":reason
  //           });
  // }
}
}
