import 'package:Arkroot/core/data/models/auth_user_model.dart';
import 'package:Arkroot/core/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> signInWithEmailAndPassword(String email, String password);
  Future<AuthUser> signUpWithEmailAndPassword(
    String fullName,
    String email,
    String password,
  );
  Future<AuthUserModel> signInWithGoogle();
  Future<void> signOut();
}
