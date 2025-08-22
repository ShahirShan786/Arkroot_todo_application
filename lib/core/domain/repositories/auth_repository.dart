import 'package:arkroot_todo_app/core/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> signInWithEmailAndPassword(String email , String password);
  Future<AuthUser> signUpWithEmailAndPassword(String fullName , String email , String password);
  Future<void> signOut();
}