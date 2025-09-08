import 'package:Arkroot/core/domain/entities/auth_user.dart';
import 'package:Arkroot/core/domain/repositories/auth_repository.dart';

class SignupUsecases {
  final AuthRepository _repository;

  SignupUsecases(this._repository);

  Future<AuthUser> call(String name, String email, String password) {
    return _repository.signUpWithEmailAndPassword(name, email, password);
  }
}
