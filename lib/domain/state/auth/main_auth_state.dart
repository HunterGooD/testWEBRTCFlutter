import 'package:flutter_webrtc_pion/domain/repository/auth_repository.dart';
import 'package:flutter_webrtc_pion/domain/state/auth/auth_state.dart';

class MainAuthState extends AuthState {
  MainAuthState(AuthRepository authRepo) : super(authRepo);
}
