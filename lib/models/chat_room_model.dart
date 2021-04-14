class ChatRoomModel {
  final String id;
  final String userID;
  final String otherUserId;
  final String otherUserName;
  final String chatId;
  final int version;

  ChatRoomModel({
    this.id,
    this.userID,
    this.otherUserId,
    this.otherUserName,
    this.version,
    this.chatId,
  });
  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userID = json['userID'],
        otherUserId = json['otherUserId'],
        otherUserName = json['otherUserName'],
        version = json['_version'],
        chatId = json['chatId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userID,
        'otherUserId': otherUserId,
        'otherUserName': otherUserName,
        'version': version,
        'chatId': chatId,
      };
}
