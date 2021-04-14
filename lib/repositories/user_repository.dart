import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_amplify_demo/models/user_model.dart';
import 'package:flutter_amplify_demo/repositories/auth_repository.dart';
import 'package:flutter_amplify_demo/services/api_service/queries.dart';
import 'package:uuid/uuid.dart';

abstract class UserRepository {
  Future<UserModel> getCurrUser();
  Future<List<UserModel>> getAllOtherUser();
  Future addUserToChatList(UserModel user);

  UserModel currUser;
  List<UserModel> allOtherUser;
  List<UserModel> userChatList;
}

class UserRepositoryClass implements UserRepository {
  AuthRepositoryClass _authRepository;
  UserRepositoryClass() {
    _authRepository = AuthRepositoryClass();
  }

  @override
  List<UserModel> userChatList;

  @override
  List<UserModel> allOtherUser;

  @override
  Future<UserModel> getCurrUser() async {
    try {
      final data = await _authRepository.getUserFromGraphql();
      UserModel user = UserModel.fromJson(data['getUser']);
      currUser = user;
      return user;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getAllOtherUser() async {
    List<UserModel> renderedData = [];
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: Queries.getAllOtherUser,
      ),
    );
    var response = await operation.response;
    var allUsers = json.decode(response.data);
    AuthUser authUser = await Amplify.Auth.getCurrentUser();

    await allUsers['listUsers']['items'].forEach((item) {
      if (item['_deleted'] == null && item['id'] != authUser.userId) {
        renderedData.add(UserModel.fromJson(item));
      }
    });
    allOtherUser = renderedData;
    return renderedData;
  }

  @override
  Future addUserToChatList(user) async {
    try {
      String chatId = Uuid().v4();
      Map<String, dynamic> mutationData = {
        'chatId': chatId,
        "otherUserId": user.id,
        'otherUserName': user.username,
        'userID': currUser.id,
      };
      var operation = Amplify.API.mutate(
        request: GraphQLRequest(
          document: Queries.createChatRoom,
          variables: mutationData,
        ),
      );
      await operation.response;

      Map<String, dynamic> otherUsermutationData = {
        'chatId': chatId,
        "otherUserId": currUser.id,
        'otherUserName': currUser.username,
        'userID': user.id,
      };
      var otherUserOperation = Amplify.API.mutate(
        request: GraphQLRequest(
          document: Queries.createChatRoom,
          variables: otherUsermutationData,
        ),
      );
      await otherUserOperation.response;
      await getCurrUser();
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  UserModel currUser;
}
