import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_amplify_demo/models/chat_model.dart';
import 'package:flutter_amplify_demo/services/api_service/queries.dart';

abstract class ChatRepository {
  Future<List<ChatModel>> getChatData(String chatId);
  Future addChatData(String message, String chatId);
  Future updateChatData(
    String messageId,
    String updatedMessage,
    int currVersion,
    String chatRoomId,
  );
  Future deleteChatData(String messageId, int currVersion);
  List<ChatModel> chatData;
}

class ChatRepositoryClass implements ChatRepository {
  @override
  Future<List<ChatModel>> getChatData(String chatId) async {
    List<ChatModel> chatDataTemp = [];
    var operation = Amplify.API.mutate(
        request: GraphQLRequest(
      document: Queries.getChatData,
      variables: {"chatRoomId": chatId},
    ));
    var response = await operation.response;
    var data = json.decode(response.data);
    if (data['listChatDatas']['items'].length > 0) {
      data['listChatDatas']['items'].forEach((item) {
        if (item['_deleted'] == null)
          chatDataTemp.add(ChatModel.fromJson(item));
      });
    }
    chatDataTemp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    chatData = chatDataTemp;
    return chatDataTemp;
  }

  @override
  Future addChatData(String message, String chatId) async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: Queries.addChatData,
        variables: {
          "chatRoomId": chatId,
          "createdAt": DateTime.now().toIso8601String() + "Z",
          "message": message,
          "senderId": authUser.userId,
        },
      ),
    );
    var response = await operation.response;
    var data = json.decode(response.data);
    if (data['createChatData'] == null) throw "Unexpected Error";
  }

  @override
  List<ChatModel> chatData = [];

  @override
  Future updateChatData(
    String messageId,
    String updatedMessage,
    int currVersion,
    String chatRoomId,
  ) async {
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: Queries.updateChatData,
        variables: {
          "id": messageId,
          "message": updatedMessage,
          "_version": currVersion,
        },
      ),
    );
    var response = await operation.response;
    var data = json.decode(response.data);
    if (data['updateChatData']['id'] == null) throw "Unexpected Error";
  }

  @override
  Future deleteChatData(String messageId, int currVersion) async {
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: Queries.deleteChatData,
        variables: {
          "id": messageId,
          "_version": currVersion,
        },
      ),
    );
    var response = await operation.response;
    var data = json.decode(response.data);
    if (data['deleteChatData']['id'] == null) throw "Unexpected Error";
  }
}
