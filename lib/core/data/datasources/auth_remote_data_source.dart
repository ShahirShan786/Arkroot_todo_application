import 'package:arkroot_todo_app/core/domain/entities/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthRemoteDataSource(this._auth);

  Future<AuthUserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;
    return AuthUserModel.fromFirebaseUser(user);
  }

  // SignUp
  Future<AuthUser> signUpWithEmailAndPhone({
    required String fullName,
    required String email,
    required String password,
   
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('Users').doc(userCredential.user!.uid).set({
      'fullName' : fullName
    });
    return AuthUser(uid: userCredential.user!.uid ,
    email: userCredential.user!.email,
    name: fullName
    );
    
  }
  
  Future<void> signOut() async => await _auth.signOut();
}
