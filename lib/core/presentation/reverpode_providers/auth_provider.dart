import 'package:Arkroot/core/data/datasources/auth_remote_data_source.dart';
import 'package:Arkroot/core/data/repositories/auth_repository_impl.dart';
import 'package:Arkroot/core/domain/usecases/signin_usecase.dart';
import 'package:Arkroot/core/domain/usecases/signin_with_google_usecases.dart';
import 'package:Arkroot/core/domain/usecases/signup_usecases.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DataSource Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(FirebaseAuth.instance),
);

// Repository Provider
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

// useCase Provider
final signInUseCaseProvider = Provider((ref) {
  final repo = ref.read(authRepositoryProvider);
  return SignInUseCase(repo);
});

final signInWithGoogleProvider = Provider((ref) {
  final repo = ref.read(authRepositoryProvider);
  return SignInWithGoogleUsecases(repo);
});

// StateNotifier for Authentication
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final SignInUseCase _signInUseCase;
  final SignInWithGoogleUsecases _signInWithGoogleUsecases;
  AuthNotifier(this._signInUseCase, this._signInWithGoogleUsecases)
    : super(const AsyncLoading()) {
    _initializeAuthState();
  }

  void _initializeAuthState() {
    final currentUser = FirebaseAuth.instance.currentUser;
    state = AsyncData(currentUser);

    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (state is! AsyncLoading) {
        state = AsyncData(user);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    try {
      final result = await _signInUseCase(email, password);

      final currentUser = FirebaseAuth.instance.currentUser;

      state = AsyncData(currentUser);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      await _signInWithGoogleUsecases
          .signInWithGoogelCall(); 
      state = AsyncData(FirebaseAuth.instance.currentUser);
    } catch (e, st) {
      state = AsyncError(e, st); 
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    try {
      await FirebaseAuth.instance.signOut();

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// For SignUp Usecases
final signupUsecasesProvider = Provider(
  (ref) => SignupUsecases(ref.read(authRepositoryProvider)),
);

// SignUp Notifier
class SignUpNotifier extends StateNotifier<AsyncValue<void>> {
  final SignupUsecases _signUpUseCase;

  SignUpNotifier(this._signUpUseCase) : super(const AsyncData(null));

  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncLoading();

    try {
      await _signUpUseCase(name, email, password);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// for sing in

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
      final signInUseCase = ref.read(signInUseCaseProvider);
      final signInWithGoogleUsecases = ref.read(signInWithGoogleProvider);
      return AuthNotifier(signInUseCase, signInWithGoogleUsecases);
    });

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
