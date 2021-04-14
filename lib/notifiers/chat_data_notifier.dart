import 'package:flutter_amplify_demo/models/chat_model.dart';
import 'package:flutter_amplify_demo/repositories/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDataNotifier extends StateNotifier<ChatDataState> {
  final ChatRepository _chatRepository;
  ChatDataNotifier(this._chatRepository) : super(ChatDataInitial());

  Future<void> getChatData(String chatRoomId) async {
    try {
      List<ChatModel> chatData = await _chatRepository.getChatData(chatRoomId);
      if (chatData.length > 0)
        state = ChatDataSuccess(chatData);
      else
        state = ChatDataSuccess([]);
    } catch (e) {
      print(e.toString());
      state = ChatDataError(e.toString());
    }
  }

  Future<void> addChatData(String chatRoomId, String message) async {
    try {
      await _chatRepository.addChatData(message, chatRoomId);
    } catch (e) {
      print(e.toString());
      state = ChatDataError(e.toString());
    }
  }

  Future<void> updateChatData(
    String messageId,
    String updatedMessage,
    int currVersion,
    String chatRoomId,
  ) async {
    try {
      await _chatRepository.updateChatData(
        messageId,
        updatedMessage,
        currVersion,
        chatRoomId,
      );
    } catch (e) {
      print(e.toString());
      state = ChatDataError(e.toString());
    }
  }

  Future<void> deleteChatData(
    String messageId,
    int currVersion,
  ) async {
    try {
      await _chatRepository.deleteChatData(
        messageId,
        currVersion,
      );
    } catch (e) {
      print(e.toString());
      state = ChatDataError(e.toString());
    }
  }
}

abstract class ChatDataState {
  const ChatDataState();
}

class ChatDataInitial extends ChatDataState {
  const ChatDataInitial();
}

class ChatDataLoading extends ChatDataState {
  const ChatDataLoading();
}

class ChatDataSuccess extends ChatDataState {
  final List<ChatModel> chatData;

  ChatDataSuccess(this.chatData);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ChatDataSuccess && o.chatData == chatData;
  }

  @override
  int get hashCode => chatData.hashCode;
}

class ChatDataError extends ChatDataState {
  final String error;

  ChatDataError(this.error);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ChatDataError && o.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
