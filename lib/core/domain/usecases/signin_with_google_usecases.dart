import 'package:arkroot_todo_app/core/data/models/auth_user_model.dart';
import 'package:arkroot_todo_app/core/data/repositories/auth_repository_impl.dart';

class SignInWithGoogleUsecases {
  final AuthRepositoryImpl authRepositoryImpl;

  SignInWithGoogleUsecases(this.authRepositoryImpl);

  Future<AuthUserModel> signInWithGoogelCall() async{
    return await authRepositoryImpl.signInWithGoogle();
  }
}