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

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the ChatData type in your schema. */
@immutable
class ChatData extends Model {
  static const classType = const ChatDataType();
  final String id;
  final String message;
  final TemporalDateTime createdAt;
  final String chatRoomId;
  final String senderId;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const ChatData._internal(
      {@required this.id,
      this.message,
      this.createdAt,
      this.chatRoomId,
      this.senderId});

  factory ChatData(
      {String id,
      String message,
      TemporalDateTime createdAt,
      String chatRoomId,
      String senderId}) {
    return ChatData._internal(
        id: id == null ? UUID.getUUID() : id,
        message: message,
        createdAt: createdAt,
        chatRoomId: chatRoomId,
        senderId: senderId);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatData &&
        id == other.id &&
        message == other.message &&
        createdAt == other.createdAt &&
        chatRoomId == other.chatRoomId &&
        senderId == other.senderId;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("ChatData {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("message=" + "$message" + ", ");
    buffer.write("createdAt=" +
        (createdAt != null ? createdAt.format() : "null") +
        ", ");
    buffer.write("chatRoomId=" + "$chatRoomId" + ", ");
    buffer.write("senderId=" + "$senderId");
    buffer.write("}");

    return buffer.toString();
  }

  ChatData copyWith(
      {String id,
      String message,
      TemporalDateTime createdAt,
      String chatRoomId,
      String senderId}) {
    return ChatData(
        id: id ?? this.id,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
        chatRoomId: chatRoomId ?? this.chatRoomId,
        senderId: senderId ?? this.senderId);
  }

  ChatData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        message = json['message'],
        createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        chatRoomId = json['chatRoomId'],
        senderId = json['senderId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'createdAt': createdAt?.format(),
        'chatRoomId': chatRoomId,
        'senderId': senderId
      };

  static final QueryField ID = QueryField(fieldName: "chatData.id");
  static final QueryField MESSAGE = QueryField(fieldName: "message");
  static final QueryField CREATEDAT = QueryField(fieldName: "createdAt");
  static final QueryField CHATROOMID = QueryField(fieldName: "chatRoomId");
  static final QueryField SENDERID = QueryField(fieldName: "senderId");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatData";
    modelSchemaDefinition.pluralName = "ChatData";

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
        key: ChatData.MESSAGE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: ChatData.CREATEDAT,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: ChatData.CHATROOMID,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: ChatData.SENDERID,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));
  });
}

class ChatDataType extends ModelType<ChatData> {
  const ChatDataType();

  @override
  ChatData fromJson(Map<String, dynamic> jsonData) {
    return ChatData.fromJson(jsonData);
  }
}
