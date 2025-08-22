// // features/auth/data/datasources/auth_remote_datasource.dart
// import 'package:arkroot_todo_app/core/error/faiures.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../models/auth_user_model.dart';

// abstract class AuthRemoteDataSource {
//   Future<AuthUserModel> signInWithEmail(String email, String password);
//   Future<void> signOut();
//   Stream<AuthUserModel?> authStateChanges();
// }

// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final FirebaseAuth _auth;
//   AuthRemoteDataSourceImpl(this._auth);

//   @override
//   Future<AuthUserModel> signInWithEmail(String email, String password) async {
//     try {
//       final cred = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final user = cred.user;
//       if (user == null) {
//         throw const AuthFailure(code: 'unknown', message: 'No user returned.');
//       }
//       return AuthUserModel.fromFirebaseUser(user);
//     } on FirebaseAuthException catch (e) {
//       // Map Firebase codes to domain-safe failures
//       switch (e.code) {
//         case 'user-not-found':
//           throw const AuthFailure(code: 'user-not-found', message: 'User not found');
//         case 'wrong-password':
//           throw const AuthFailure(code: 'wrong-password', message: 'Wrong password');
//         case 'invalid-email':
//           throw const AuthFailure(code: 'invalid-email', message: 'Invalid email');
//         default:
//           throw AuthFailure(code: e.code, message: e.message ?? 'Auth error');
//       }
//     } catch (_) {
//       throw const AuthFailure(code: 'unknown', message: 'Unexpected error');
//     }
//   }

//   @override
//   Future<void> signOut() => _auth.signOut();

//   @override
//   Stream<AuthUserModel?> authStateChanges() {
//     return _auth.authStateChanges().map((user) {
//       if (user == null) return null;
//       return AuthUserModel.fromFirebaseUser(user);
//     });
//   }
// }











// import 'dart:math';

// import 'package:arkroot_todo_app/core/data/models/auth_user_model.dart';
// import 'package:arkroot_todo_app/core/presentation/utils/message_generator.dart';
// import 'package:arkroot_todo_app/core/presentation/utils/my_app_exception.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// class RemoteDataSource {
//   Future<AuthUserModel> authenticateUser(String email, String password) async {

// try {
//   final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//     email: email,
//     password: password
//   );
//   AuthUserModel authUserModel = AuthUserModel(email: credential.user?.email);
//   return authUserModel;
// } on FirebaseAuthException catch (e) {
//   if (e.code == 'user-not-found') {
//       throw MyAppException(
//         title: MessageGenerator.getMessage("User Not Found"),
//         message: MessageGenerator.getMessage("User is not registered"),
//       );
 
//   } else if (e.code == 'wrong-password') {
//     print('Wrong password provided for that user.');
//       throw MyAppException(
//         title: MessageGenerator.getMessage("Invalid Credentials"),
//         message: MessageGenerator.getMessage("You entered a wrong password"),
//       );
//   }else{
//       throw MyAppException(
//         title: MessageGenerator.getMessage("Unexpected Error"),
//         message: MessageGenerator.getMessage("Please try again later"),
//       );
//   }
// } on Exception catch(e){
//     throw MyAppException(
//         title: MessageGenerator.getMessage("Auth Error"),
//         message: MessageGenerator.getMessage("Invalid credentials"),
//       );
// }



   

//     // Convert JSON data to UserModel instance

//   }
// }
