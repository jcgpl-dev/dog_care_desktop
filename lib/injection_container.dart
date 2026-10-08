import 'package:dog_care_desktop/app/presentation/shell/cubit/sidebar_cubit.dart';
import 'package:dog_care_desktop/features/auth/domain/usecases/logout.dart';
import 'package:dog_care_desktop/features/dogs/data/datasources/local/mock_dogs_datasource.dart';
import 'package:dog_care_desktop/features/dogs/data/repositories/dogs_repository_impl.dart';
import 'package:dog_care_desktop/features/dogs/domain/repositories/dogs_repository.dart';
import 'package:dog_care_desktop/features/dogs/domain/usecases/delete_dog.dart';
import 'package:dog_care_desktop/features/dogs/domain/usecases/get_dogs.dart';
import 'package:dog_care_desktop/features/dogs/domain/usecases/register_dog.dart';
import 'package:dog_care_desktop/features/dogs/presentation/bloc/dogs_bloc.dart';
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
  sl.registerFactory(() => AuthBloc(login: sl(), logout: sl()));

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Repository (depends on AuthDataSource interface)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl<AuthDataSource>()),
  );

  sl.registerLazySingleton<AuthDataSource>(() => MockAuthDataSource());

  // Features - Dogs
  sl.registerFactory(
    () => DogsBloc(getDogs: sl(), registerDog: sl(), deleteDog: sl()),
  );

  sl.registerLazySingleton(() => GetDogs(sl()));
  sl.registerLazySingleton(() => RegisterDog(sl()));
  sl.registerLazySingleton(() => DeleteDog(sl()));

  sl.registerLazySingleton<DogsRepository>(
    () => DogsRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<DogsDataSource>(() => MockDogsDataSource());
}
