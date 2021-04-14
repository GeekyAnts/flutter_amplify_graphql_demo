import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_amplify_demo/services/api_service/queries.dart';

abstract class AuthRepository {
  Future<bool> loginWithEmailPassword(String email, String password);
  Future<bool> loginWithGoogle();
  Future<bool> signupWithEmailPassword(
    String email,
    String password,
    String name,
  );
  Future<bool> otpVerfication(
    String email,
    String otp,
    String name,
    String password,
  );
  Future<bool> hasUsername();
  Future<bool> updateName(String name);
  Future<dynamic> getUserFromGraphql();
}

class AuthRepositoryClass implements AuthRepository {
  @override
  Future<bool> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      return res.isSignedIn;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<bool> signupWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      Map<String, String> userAttributes = {'name': name};
      await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );
      return true;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> otpVerfication(
    String email,
    String otp,
    String name,
    String password,
  ) async {
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: otp,
      );
      if (res.isSignUpComplete) {
        SignInResult signInRes = await Amplify.Auth.signIn(
          username: email,
          password: password,
        );
        if (signInRes.isSignedIn) {
          AuthUser authUser = await Amplify.Auth.getCurrentUser();
          var operation = Amplify.API.mutate(
            request: GraphQLRequest(
              document: Queries.createUserFromEmail,
              variables: {
                "id": authUser.userId,
                "username": name,
                "email": email,
                "bio": "",
                "createdAt": DateTime.now().toIso8601String() + "Z",
                "isVerified": false,
              },
            ),
          );
          var response = await operation.response;
          var data = json.decode(response.data);
          if (data["createUser"]["id"] != null)
            return true;
          else
            return false;
        }
        return false;
      }
      return false;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> loginWithGoogle() async {
    try {
      var res = await Amplify.Auth.signInWithWebUI(
        provider: AuthProvider.google,
      );
      final authUserAttributes = await Amplify.Auth.fetchUserAttributes();
      String email;
      String userId;
      authUserAttributes.forEach((element) {
        if (element.userAttributeKey == "email")
          email = element.value;
        else if (element.userAttributeKey == "sub") userId = element.value;
      });
      var data = await getUserFromGraphql();
      if (data['getUser'] != null) {
        return res.isSignedIn;
      } else {
        var operation = Amplify.API.mutate(
          request: GraphQLRequest(
            document: Queries.createUserMutation,
            variables: {
              "createdAt": DateTime.now().toIso8601String() + "Z",
              "email": email,
              "username": "Not Available",
              "id": userId,
              "chats": null,
            },
          ),
        );
        var response = await operation.response;
        var data = json.decode(response.data);
        if (data['createUser']['id'] != null)
          return true;
        else
          return false;
      }
    } on AmplifyException catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> updateName(String name) async {
    final data = await getUserFromGraphql();
    var _version = data['getUser']['_version'];
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: Queries.updateUserName,
        variables: {
          "id": data['getUser']['id'],
          "username": name,
          "_version": _version,
        },
      ),
    );
    var response = await operation.response;
    var resData = json.decode(response.data);
    if (resData['updateUser']['id'] != null)
      return true;
    else
      return false;
  }

  @override
  Future getUserFromGraphql() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      var operation = Amplify.API.mutate(
        request: GraphQLRequest(
          document: Queries.getCurrUser,
          variables: {"id": authUser.userId},
        ),
      );
      var response = await operation.response;
      var data = json.decode(response.data);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> hasUsername() async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    var operation = Amplify.API.mutate(
      request: GraphQLRequest(
        document: Queries.hasUserName,
        variables: {"id": authUser.userId},
      ),
    );
    var response = await operation.response;
    var data = json.decode(response.data);
    if (data['getUser']['username'] != "Not Available") {
      return true;
    } else
      return false;
  }
}
