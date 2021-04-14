import 'package:flutter_amplify_demo/models/user_model.dart';
import 'package:flutter_amplify_demo/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateUserDataNotifier extends StateNotifier<UpdateUserDataState> {
  final UserRepository _userRepository;

  UpdateUserDataNotifier(this._userRepository) : super(UpdateUserDataInitial());

  Future<void> getUser() async {
    try {
      state = UpdateUserDataLoading();
      UserModel user = await _userRepository.getCurrUser();
      if (user.id != null)
        state = UpdateUserDataSuccess(user);
      else
        state = UpdateUserDataError("Unknown error");
    } catch (e) {
      state = UpdateUserDataError(e.toString());
    }
  }
}

abstract class UpdateUserDataState {
  const UpdateUserDataState();
}

class UpdateUserDataInitial extends UpdateUserDataState {
  const UpdateUserDataInitial();
}

class UpdateUserDataLoading extends UpdateUserDataState {
  const UpdateUserDataLoading();
}

class UpdateUserDataSuccess extends UpdateUserDataState {
  final UserModel user;

  UpdateUserDataSuccess(this.user);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is UpdateUserDataSuccess && o.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}

class UpdateUserDataError extends UpdateUserDataState {
  final String error;

  UpdateUserDataError(this.error);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is UpdateUserDataError && o.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
