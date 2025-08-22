// import 'package:arkroot_todo_app/core/data/datasources/remote_data_source.dart';
// import 'package:arkroot_todo_app/core/data/repositories/user_repository_impl.dart';
// import 'package:arkroot_todo_app/core/domain/repositories/user_repository.dart';
// import 'package:arkroot_todo_app/core/domain/usecases/authentication.dart';
// import 'package:get_it/get_it.dart';

// void setupDependencies() {
//   // Register the UserRepository and RemoteDataSource with GetIt
//   GetIt.instance.registerLazySingleton<UserRepository>(
//     () => UserRepositoryImpl(AuthRemoteDataSource()),
//   );

//   // Register the AuthenticateUserUseCase with GetIt, initializing it with UserRepository
//   GetIt.instance.registerLazySingleton<AuthenticationUseCase>(
//     () => AuthenticationUseCase(GetIt.instance<UserRepository>()),
//   );
// }
