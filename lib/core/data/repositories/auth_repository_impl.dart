import 'package:arkroot_todo_app/core/data/datasources/auth_remote_data_source.dart';
import 'package:arkroot_todo_app/core/data/models/auth_user_model.dart';
import 'package:arkroot_todo_app/core/domain/entities/auth_user.dart';
import 'package:arkroot_todo_app/core/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<AuthUser> signInWithEmailAndPassword(String email, String password) async{
    return await  authRemoteDataSource.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() {
    return authRemoteDataSource.signOut();
  }
  
  @override
  Future<AuthUser> signUpWithEmailAndPassword(String fullName,  String email, String password) async{
    
    return await authRemoteDataSource.signUpWithEmailAndPhone( fullName: fullName, email: email, password: password,);
  }

  @override
  Future<AuthUserModel> signInWithGoogle()async {
    return await authRemoteDataSource.signInWithGoogle();
  }
}
