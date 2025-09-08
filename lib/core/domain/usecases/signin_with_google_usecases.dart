import 'package:Arkroot/core/data/models/auth_user_model.dart';
import 'package:Arkroot/core/data/repositories/auth_repository_impl.dart';

class SignInWithGoogleUsecases {
  final AuthRepositoryImpl authRepositoryImpl;

  SignInWithGoogleUsecases(this.authRepositoryImpl);

  Future<AuthUserModel> signInWithGoogelCall() async {
    return await authRepositoryImpl.signInWithGoogle();
  }
}
