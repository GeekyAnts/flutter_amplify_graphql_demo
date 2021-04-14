import 'package:flutter_amplify_demo/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpVerificationNotifier extends StateNotifier<OtpVerificationState> {
  final AuthRepository _authRepository;

  OtpVerificationNotifier(this._authRepository)
      : super(OtpVerificationInitial());

  Future<void> verify(
    String email,
    String otp,
    String name,
    String password,
  ) async {
    try {
      state = OtpVerificationLoading();
      bool success = await _authRepository.otpVerfication(
        email,
        otp,
        name,
        password,
      );
      if (success)
        state = OtpVerificationSuccess(true);
      else
        state = OtpVerificationError("Unknown error");
    } catch (e) {
      print(e.toString());
      state = OtpVerificationError(e.toString());
    }
  }
}

abstract class OtpVerificationState {
  const OtpVerificationState();
}

class OtpVerificationInitial extends OtpVerificationState {
  const OtpVerificationInitial();
}

class OtpVerificationLoading extends OtpVerificationState {
  const OtpVerificationLoading();
}

class OtpVerificationSuccess extends OtpVerificationState {
  final bool success;

  OtpVerificationSuccess(this.success);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is OtpVerificationSuccess && o.success == success;
  }

  @override
  int get hashCode => success.hashCode;
}

class OtpVerificationError extends OtpVerificationState {
  final String error;

  OtpVerificationError(this.error);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is OtpVerificationError && o.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
