import 'package:dog_care_desktop/app/presentation/shell/cubit/sidebar_cubit.dart';
import 'package:get_it/get_it.dart';

import 'features/auth/data/datasources/auth_datasource.dart';
import 'features/auth/data/datasources/local/mock_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'config/theme/cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth

  sl.registerLazySingleton(() => ThemeCubit());
  sl.registerLazySingleton(() => SidebarCubit());

  // BLoC
  sl.registerFactory(() => AuthBloc(login: sl()));

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));

  // Repository (depends on AuthDataSource interface)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl<AuthDataSource>()),
  );

  sl.registerLazySingleton<AuthDataSource>(() => MockAuthDataSource());
}
