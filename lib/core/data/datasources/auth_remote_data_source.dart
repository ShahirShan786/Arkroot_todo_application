import 'package:Arkroot/core/data/models/auth_user_model.dart';
import 'package:Arkroot/core/domain/entities/auth_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // CORRECTED: Access the singleton instance instead of creating a new one.
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthRemoteDataSource(this._auth);

  // Google Sign In
  Future<AuthUserModel> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final googleUser = await _googleSignIn.signIn();
      // Handle the case where the user cancels the sign-in flow
      if (googleUser == null) {
        throw Exception("Google Sign-In aborted by user");
      }

      // Obtain auth details
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Save to Firestore if new user
      final userDoc = _firestore.collection("Users").doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          "fullName": user.displayName,
          "email": user.email,
          "photoUrl": user.photoURL,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return AuthUserModel.fromFirebaseUser(user);
    } catch (e) {
      // Re-throw with a more specific error message for easier debugging
      throw Exception("Google Sign-In failed: $e");
    }
  }

  //   Future<AuthUserModel> signInWithGoogle() async {
  //   try {
  //     if (kIsWeb) {
  //       // 🔹 Use Firebase Web Sign-In
  //       final GoogleAuthProvider googleProvider = GoogleAuthProvider();

  //       final userCredential = await _auth.signInWithPopup(googleProvider);
  //       final user = userCredential.user!;

  //       // Save to Firestore if new user
  //       final userDoc = _firestore.collection("Users").doc(user.uid);
  //       final docSnapshot = await userDoc.get();

  //       if (!docSnapshot.exists) {
  //         await userDoc.set({
  //           "fullName": user.displayName,
  //           "email": user.email,
  //           "photoUrl": user.photoURL,
  //           "createdAt": FieldValue.serverTimestamp(),
  //         });
  //       }

  //       return AuthUserModel.fromFirebaseUser(user);
  //     } else {
  //       // 🔹 Mobile (Android/iOS) Flow
  //       final googleUser = await _googleSignIn.signIn();
  //       if (googleUser == null) {
  //         throw Exception("Google Sign-In aborted by user");
  //       }

  //       final googleAuth = await googleUser.authentication;

  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

  //       final userCredential = await _auth.signInWithCredential(credential);
  //       final user = userCredential.user!;

  //       final userDoc = _firestore.collection("Users").doc(user.uid);
  //       final docSnapshot = await userDoc.get();

  //       if (!docSnapshot.exists) {
  //         await userDoc.set({
  //           "fullName": user.displayName,
  //           "email": user.email,
  //           "photoUrl": user.photoURL,
  //           "createdAt": FieldValue.serverTimestamp(),
  //         });
  //       }

  //       return AuthUserModel.fromFirebaseUser(user);
  //     }
  //   } catch (e) {
  //     throw Exception("Google Sign-In failed: $e");
  //   }
  // }

  // Existing email/password sign-in (unchanged)
  Future<AuthUserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return AuthUserModel.fromFirebaseUser(credential.user!);
  }

  

  // Existing sign-up (unchanged)
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
      'fullName': fullName,
    });

    return AuthUser(
      uid: userCredential.user!.uid,
      email: userCredential.user!.email,
      name: fullName,
    );
  }

  // Corrected sign out method
  Future<void> signOut() async {
    // It's best practice to sign out from Google first
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
