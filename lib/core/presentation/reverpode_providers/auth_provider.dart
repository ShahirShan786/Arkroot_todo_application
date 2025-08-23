import 'package:arkroot_todo_app/core/data/datasources/auth_remote_data_source.dart';
import 'package:arkroot_todo_app/core/data/repositories/auth_repository_impl.dart';
import 'package:arkroot_todo_app/core/domain/usecases/signin_usecase.dart';
import 'package:arkroot_todo_app/core/domain/usecases/signin_with_google_usecases.dart';
import 'package:arkroot_todo_app/core/domain/usecases/signup_usecases.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DataSource Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(FirebaseAuth.instance),
);

// Repository Provider
final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) {
    final remoteDataSource = ref.read(authRemoteDataSourceProvider);
    return AuthRepositoryImpl(remoteDataSource);
  }
);

// useCase Provider
final signInUseCaseProvider = Provider(
  (ref) {
    final repo = ref.read(authRepositoryProvider);
    return SignInUseCase(repo);
  }
);

final signInWithGoogleProvider = Provider(
  (ref){
    final repo = ref.read(authRepositoryProvider);
    return SignInWithGoogleUsecases(repo);
  }
);

// StateNotifier for Authentication
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final SignInUseCase _signInUseCase;
  final SignInWithGoogleUsecases _signInWithGoogleUsecases;
  AuthNotifier(this._signInUseCase , this._signInWithGoogleUsecases) : super(const AsyncData(null));

  Future<void> signIn(String email, String password) async {
    print("Starting sign in for: $email");
    state = const AsyncLoading();

    try {
      final result = await _signInUseCase(email, password);
      print("Sign in successful: $result");
      final currentUser = FirebaseAuth.instance.currentUser;
      print("Current user: ${currentUser?.email}");
      state = AsyncData(currentUser);
    } catch (e, st) {
      print("Sign in error: $e");
      state = AsyncError(e, st);
    }
  }


 Future<void> signInWithGoogle() async {
  state = const AsyncLoading();
  try {
    await _signInWithGoogleUsecases.signInWithGoogelCall(); // ✅ call the method
    state = AsyncData(FirebaseAuth.instance.currentUser);
  } catch (e, st) {
    state = AsyncError(e, st); // optional: catch stack trace as well
    print("Google Sign-In error: $e");
  }
}

    Future<void> signOut() async {
    print("Starting sign out");
    state = const AsyncLoading();
    
    try {
      await FirebaseAuth.instance.signOut();
      print("Sign out successful");
      state = const AsyncData(null);
    } catch (e, st) {
      print("Sign out error: $e");
      state = AsyncError(e, st);
    }
  }
}

// For SignUp Usecases
final signupUsecasesProvider = Provider(
  (ref) => SignupUsecases(ref.read(authRepositoryProvider))
);

// SignUp Notifier
class SignUpNotifier extends StateNotifier<AsyncValue<void>> {
  final SignupUsecases _signUpUseCase;

  SignUpNotifier(this._signUpUseCase) : super(const AsyncData(null));

  Future<void> signUp(String name, String email, String password) async {
    print('SignUpNotifier: Starting signup for $email with name: $name');
    state = const AsyncLoading();
    
    try {
      await _signUpUseCase(name, email , password);
      print('SignUpNotifier: Signup successful');
      state = const AsyncData(null);
    } catch (e, st) {
      print('SignUpNotifier: Signup failed - $e');
      state = AsyncError(e, st);
    }
  }
}


// for sing in 

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (ref) {
 final signInUseCase = ref.read(signInUseCaseProvider);
    final signInWithGoogleUsecases = ref.read(signInWithGoogleProvider);
    return AuthNotifier(signInUseCase, signInWithGoogleUsecases);
  },
);

// Alternative: If you prefer to keep the current structure, 
// create a separate provider for auth state
final authStateProvider = Provider<AsyncValue<bool>>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);
  
  return authNotifier.when(
    data: (user) => AsyncData(user != null),
    loading: () => const AsyncLoading(),
    error: (error, stack) => AsyncError(error, stack),
  );
});


// for SignUp
final signUpNotifierProvider =
    StateNotifierProvider<SignUpNotifier, AsyncValue<void>>(
  (ref) => SignUpNotifier(ref.read(signupUsecasesProvider)),
);











// import 'package:arkroot_todo_app/core/data/datasources/auth_remote_data_source.dart';
// import 'package:arkroot_todo_app/core/data/repositories/auth_repository_impl.dart';
// import 'package:arkroot_todo_app/core/domain/usecases/signin_usecase.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';



// // DataSource Provider
// final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
//   (ref) => AuthRemoteDataSource(FirebaseAuth.instance),
// );


// // Repository Provider
// final authRepositoryProvider = Provider<AuthRepositoryImpl>(
//   (ref){
//     final remoteDataSource = ref.read(authRemoteDataSourceProvider);
//     return AuthRepositoryImpl(remoteDataSource);
//   }
// );

// // useCase Provider
// final signInUseCaseProvider = Provider(
//   (ref){
//     final repo = ref.read(authRepositoryProvider);
//     return SignInUseCase(repo);
//   }
// );


// // StateNotifier for Authentication

// class AuthNotifier extends StateNotifier<AsyncValue<void>> {
//   final SignInUseCase _signInUseCase;

//   AuthNotifier(this._signInUseCase) : super(const AsyncData(null));

//   Future<void> signIn(String email , String password) async {
//     state = const AsyncLoading();

//     try{
//     await _signInUseCase(email , password);
//     state = const AsyncData(null);
//     }catch(e, st){
//      state = AsyncError(e, st);
//     }
//   }
// }


// final authNotifierProvider =
//    StateNotifierProvider<AuthNotifier , AsyncValue<void>>(
//     (ref){
//       final signInUseCase =  ref.read(signInUseCaseProvider);
//       return AuthNotifier(signInUseCase);
//     }
//    );