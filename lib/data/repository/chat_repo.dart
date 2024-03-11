import 'package:Apka_kitchen/data/api/api_client.dart';
import 'package:Apka_kitchen/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ChatRepo {
  final ApiClient apiClient;
  ChatRepo({@required this.apiClient});


  Future<Response> getChatRepo() async {
    return await apiClient.getData('${AppConstants.getMessageURI}');
  }

}
