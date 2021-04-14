class Queries {
  static const String createUserMutation =
      '''mutation MyMutation(\$createdAt: AWSDateTime!, \$email: String!, \$username: String!, \$chats: AWSJSON, \$id: ID!) {
          createUser(input: {username: \$username, profileImage: "", email: \$email, createdAt: \$createdAt, chats: \$chats, id: \$id}) {
            id
            username
            email
          }
        }
      ''';

  static const String getCurrUser = '''query MyQuery(\$id: ID!) {
        getUser(id: \$id) {
          id
          _version
          username
          email
          bio
          profileImage
          isVerified
          createdAt
          ChatRooms {
            items {
              otherUserName
              otherUserId
              id
              _version
              _deleted
              userID
              chatId
            }
          }
        }
      }

    ''';

  static const String updateUserName =
      '''mutation MyMutation( \$id: ID!, \$username: String!, \$_version: Int!) {
          updateUser(input: {username: \$username, id: \$id, _version: \$_version}) {
            id
            profileImage
            username
            email
          }
        }
    ''';

  static const String createUserFromEmail =
      '''mutation MyMutation(\$id: ID!, \$username: String!, \$email: String, \$bio: String, \$createdAt: AWSDateTime, \$isVerified: Boolean) {
          createUser(input: {id: \$id, username: \$username, email: \$email, bio: \$bio, createdAt: \$createdAt, isVerified: \$isVerified}) {
            username
            id
          }
        }
    ''';

  static const String hasUserName = '''query hasUserName(\$id: ID!) {
          getUser(id: \$id) {
            username
            _deleted
            _version
          }
        }
      ''';

  static const String getAllOtherUser = '''query getAllOtherUser {
          listUsers {
            items {
              id
              _version
              _deleted
              username
              email
              bio
              profileImage
              isVerified
              createdAt
              chats
            }
          }
        }
      ''';

  static const String createChatRoom =
      '''mutation MyMutation(\$userID: ID, \$otherUserId: String, \$otherUserName: String, \$chatId: String) {
      createChatRoom(input: {userID: \$userID, otherUserId: \$otherUserId, otherUserName: \$otherUserName, chatId: \$chatId}) {
        otherUserId
        otherUserName
        userID
        id
        _version
      }
    }
      ''';

  static const String getChatData =
      '''query listChatDatas(\$chatRoomId: String) {
          listChatDatas(filter: {chatRoomId: {eq: \$chatRoomId}}) {
            items {
              id
              message
              chatRoomId
              _version
              senderId
              updatedAt
              _deleted
              createdAt
            }
          }
        }''';

  static const String addChatData =
      '''mutation MyMutation( \$createdAt: AWSDateTime, \$message: String, \$senderId: String, \$chatRoomId: String) {
      createChatData(input: {createdAt: \$createdAt, message: \$message, senderId: \$senderId, chatRoomId: \$chatRoomId}) {
        id
        _version
      }
    }

  ''';

  static const String updateChatData =
      '''mutation MyMutation(\$id: ID!, \$message: String, \$_version: Int) {
          updateChatData(input: {id: \$id, message: \$message, _version: \$_version}) {
            id
          }
        }
        ''';

  static const String deleteChatData =
      '''mutation MyMutation(\$id: ID, \$_version: Int) {
          deleteChatData(input: {_version: \$_version, id: \$id}) {
            id
            _version
            _deleted
          }
        }
        ''';

  static const String onCreateChatData = '''subscription OnCreateChatData {
        onCreateChatData {
          id
        }
      }
  ''';
  static const String onUpdateChatData = '''subscription OnUpdateChatData {
        onUpdateChatData {
          id
        }
      }
  ''';
  static const String onDeleteChatData = '''subscription OnDeleteChatData {
        onDeleteChatData {
          id
        }
      }
  ''';
}
