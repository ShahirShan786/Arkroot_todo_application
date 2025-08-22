// core/error/failures.dart
class AuthFailure implements Exception {
  final String code;   
  final String message;
  const AuthFailure({required this.code, required this.message});
}
