/*
* Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the User type in your schema. */
@immutable
class User extends Model {
  static const classType = const UserType();
  final String id;
  final String username;
  final String email;
  final String bio;
  final String profileImage;
  final bool isVerified;
  final TemporalDateTime createdAt;
  final String chats;
  final List<ChatRoom> ChatRooms;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const User._internal(
      {@required this.id,
      @required this.username,
      this.email,
      this.bio,
      this.profileImage,
      this.isVerified,
      this.createdAt,
      this.chats,
      this.ChatRooms});

  factory User(
      {String id,
      @required String username,
      String email,
      String bio,
      String profileImage,
      bool isVerified,
      TemporalDateTime createdAt,
      String chats,
      List<ChatRoom> ChatRooms}) {
    return User._internal(
        id: id == null ? UUID.getUUID() : id,
        username: username,
        email: email,
        bio: bio,
        profileImage: profileImage,
        isVerified: isVerified,
        createdAt: createdAt,
        chats: chats,
        ChatRooms:
            ChatRooms != null ? List.unmodifiable(ChatRooms) : ChatRooms);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        id == other.id &&
        username == other.username &&
        email == other.email &&
        bio == other.bio &&
        profileImage == other.profileImage &&
        isVerified == other.isVerified &&
        createdAt == other.createdAt &&
        chats == other.chats &&
        DeepCollectionEquality().equals(ChatRooms, other.ChatRooms);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("username=" + "$username" + ", ");
    buffer.write("email=" + "$email" + ", ");
    buffer.write("bio=" + "$bio" + ", ");
    buffer.write("profileImage=" + "$profileImage" + ", ");
    buffer.write("isVerified=" +
        (isVerified != null ? isVerified.toString() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (createdAt != null ? createdAt.format() : "null") +
        ", ");
    buffer.write("chats=" + "$chats");
    buffer.write("}");

    return buffer.toString();
  }

  User copyWith(
      {String id,
      String username,
      String email,
      String bio,
      String profileImage,
      bool isVerified,
      TemporalDateTime createdAt,
      String chats,
      List<ChatRoom> ChatRooms}) {
    return User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        bio: bio ?? this.bio,
        profileImage: profileImage ?? this.profileImage,
        isVerified: isVerified ?? this.isVerified,
        createdAt: createdAt ?? this.createdAt,
        chats: chats ?? this.chats,
        ChatRooms: ChatRooms ?? this.ChatRooms);
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        bio = json['bio'],
        profileImage = json['profileImage'],
        isVerified = json['isVerified'],
        createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        chats = json['chats'],
        ChatRooms = json['ChatRooms'] is List
            ? (json['ChatRooms'] as List)
                .map((e) => ChatRoom.fromJson(new Map<String, dynamic>.from(e)))
                .toList()
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'bio': bio,
        'profileImage': profileImage,
        'isVerified': isVerified,
        'createdAt': createdAt?.format(),
        'chats': chats,
        'ChatRooms': ChatRooms?.map((e) => e?.toJson())?.toList()
      };

  static final QueryField ID = QueryField(fieldName: "user.id");
  static final QueryField USERNAME = QueryField(fieldName: "username");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static final QueryField BIO = QueryField(fieldName: "bio");
  static final QueryField PROFILEIMAGE = QueryField(fieldName: "profileImage");
  static final QueryField ISVERIFIED = QueryField(fieldName: "isVerified");
  static final QueryField CREATEDAT = QueryField(fieldName: "createdAt");
  static final QueryField CHATS = QueryField(fieldName: "chats");
  static final QueryField CHATROOMS = QueryField(
      fieldName: "ChatRooms",
      fieldType: ModelFieldType(ModelFieldTypeEnum.model,
          ofModelName: (ChatRoom).toString()));
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.USERNAME,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.EMAIL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.BIO,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.PROFILEIMAGE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.ISVERIFIED,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.CREATEDAT,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: User.CHATS,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
        key: User.CHATROOMS,
        isRequired: false,
        ofModelName: (ChatRoom).toString(),
        associatedKey: ChatRoom.USERID));
  });
}

class UserType extends ModelType<User> {
  const UserType();

  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
}
