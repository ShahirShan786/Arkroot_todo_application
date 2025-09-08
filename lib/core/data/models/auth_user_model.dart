import 'package:Arkroot/core/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({required super.uid, required super.email});

  factory AuthUserModel.fromFirebaseUser(user) {
    return AuthUserModel(uid: user.uid, email: user.email ?? "");
  }
}



// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// @immutable
// class AuthUserModel {
//   final String? token;
//   final int? expiresIn;
//   final String? userId;
//   final String? email;

//   const AuthUserModel({
//     this.token,
//     this.expiresIn,
//     this.userId,
//     this.email,
//   });

//   @override
//   String toString() {
//     return 'AuthUserModel(token: $token, expiresIn: $expiresIn, userId: $userId, email: $email)';
//   }

//   factory AuthUserModel.fromMap(Map<String, dynamic> data) => AuthUserModel(
//         token: data['token'] as String?,
//         expiresIn: data['expiresIn'] as int?,
//         userId: data['userId'] as String?,
//         email: data['email'] as String?,
//       );

//   Map<String, dynamic> toMap() => {
//         'token': token,
//         'expiresIn': expiresIn,
//         'userId': userId,
//         'email': email,
//       };

//   factory AuthUserModel.fromJson(String data) {
//     return AuthUserModel.fromMap(json.decode(data) as Map<String, dynamic>);
//   }

//   String toJson() => json.encode(toMap());

//   /// ✅ NEW: Create from Firebase `User`
//   factory AuthUserModel.fromFirebaseUser(User user, {String? token, int? expiresIn}) {
//     return AuthUserModel(
//       token: token, // optional: you can later fetch from user.getIdToken()
//       expiresIn: expiresIn,
//       userId: user.uid,
//       email: user.email,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(other, this)) return true;
//     if (other is! AuthUserModel) return false;
//     return userId == other.userId;
//   }

//   @override
//   int get hashCode => userId.hashCode;
// }















// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// @immutable
// class AuthUserModel {
//   final String? token;
//   final int? expiresIn;
//   final String? userId;
//   final String? email;

//   const AuthUserModel({
//     this.token,
//     this.expiresIn,
//     this.userId,
//     this.email,
//   });

//   @override
//   String toString() {
//     return 'AuthUserModel(token: $token, expiresIn: $expiresIn, userId: $userId, email: $email)';
//   }

//   factory AuthUserModel.fromMap(Map<String, dynamic> data) => AuthUserModel(
//         token: data['token'] as String?,
//         expiresIn: data['expiresIn'] as int?,
//         userId: data['userId'] as String?,
//         email: data['email'] as String?,
//       );

//   Map<String, dynamic> toMap() => {
//         'token': token,
//         'expiresIn': expiresIn,
//         'userId': userId,
//         'email': email,
//       };

//   factory AuthUserModel.fromJson(String data) {
//     return AuthUserModel.fromMap(json.decode(data) as Map<String, dynamic>);
//   }

//   String toJson() => json.encode(toMap());

//   @override
//   bool operator ==(Object other) {
//     if (identical(other, this)) return true;
//     if (other is! AuthUserModel) return false;
//     return userId == other.userId;
//   }

//   @override
//   int get hashCode => userId.hashCode;
// }
