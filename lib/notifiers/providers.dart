import 'package:flutter_amplify_demo/models/user_model.dart';
import 'package:flutter_amplify_demo/notifiers/add_user_to_chatroom_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/all_other_user_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/chat_data_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/login_with_email_password_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/login_with_google_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/otp_verification_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/signup_with_email_password_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/update_user_data_notifier.dart';
import 'package:flutter_amplify_demo/repositories/auth_repository.dart';
import 'package:flutter_amplify_demo/repositories/chat_repository.dart';
import 'package:flutter_amplify_demo/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Auth repository
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryClass(),
);

/// User repository
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryClass(),
);

/// Chat repository
final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepositoryClass(),
);

/// Login with Email Password Provider
final loginWithEmailNotifierProvider = StateNotifierProvider(
  (ref) => LoginWithEmailNotifier(ref.watch(authRepositoryProvider)),
);

/// Login with Google Provider
final loginWithGoogleProvider = StateNotifierProvider(
  (ref) => LoginWithGoogleNotifier(ref.watch(authRepositoryProvider)),
);

/// Signup with Email Password Provider
final signupWithEmailNotifierProvider = StateNotifierProvider(
  (ref) => SignupWithEmailNotifier(ref.watch(authRepositoryProvider)),
);

/// Otp verification Provider
final otpVerificationProvider = StateNotifierProvider(
  (ref) => OtpVerificationNotifier(ref.watch(authRepositoryProvider)),
);

final addUserToChatRoomProvider = StateNotifierProvider(
  (ref) => AddUserToChatRoomNotifier(ref.watch(userRepositoryProvider)),
);

final chatDataProvider = StateNotifierProvider(
  (ref) => ChatDataNotifier(ref.watch(chatRepositoryProvider)),
);

final allOtherUserProvider = StateNotifierProvider(
  (ref) => AllOtherUserNotifier(ref.watch(userRepositoryProvider)),
);

final updateUserDataProvider = StateNotifierProvider(
  (ref) => UpdateUserDataNotifier(ref.watch(userRepositoryProvider)),
);

/// Get Current User provider
final currUserProvider = Provider<UserModel>((ref) {
  var currUser = ref.watch(userRepositoryProvider).currUser;
  return currUser;
});
