import 'package:flutter_amplify_demo/models/user_model.dart';
import 'package:flutter_amplify_demo/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddUserToChatRoomNotifier extends StateNotifier<AddUserToChatRoomState> {
  final UserRepository _userRepository;

  AddUserToChatRoomNotifier(this._userRepository)
      : super(AddUserToChatRoomInitial());

  Future<void> addUser(UserModel user) async {
    try {
      state = AddUserToChatRoomLoading();
      bool success = await _userRepository.addUserToChatList(user);
      if (success)
        state = AddUserToChatRoomSuccess(true);
      else
        state = AddUserToChatRoomError("Unknown error");
    } catch (e) {
      state = AddUserToChatRoomError(e.toString());
    }
  }
}

abstract class AddUserToChatRoomState {
  const AddUserToChatRoomState();
}

class AddUserToChatRoomInitial extends AddUserToChatRoomState {
  const AddUserToChatRoomInitial();
}

class AddUserToChatRoomLoading extends AddUserToChatRoomState {
  const AddUserToChatRoomLoading();
}

class AddUserToChatRoomSuccess extends AddUserToChatRoomState {
  final bool success;

  AddUserToChatRoomSuccess(this.success);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AddUserToChatRoomSuccess && o.success == success;
  }

  @override
  int get hashCode => success.hashCode;
}

class AddUserToChatRoomError extends AddUserToChatRoomState {
  final String error;

  AddUserToChatRoomError(this.error);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is AddUserToChatRoomError && o.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
