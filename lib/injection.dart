import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '2_application/auth/auth_bloc.dart';
import '2_application/conditioner/conditioner_bloc.dart';
import '2_application/settings/settings_bloc.dart';
import '3_domain/repositories/auth_repository.dart';
import '3_domain/repositories/conditioner_repository.dart';
import '3_domain/repositories/database_repository.dart';
import '3_domain/repositories/settings_repository.dart';
import '4_infrastructur/auth_repository_impl.dart';
import '4_infrastructur/conditioner_repository_impl.dart';
import '4_infrastructur/database_repository_impl.dart';
import '4_infrastructur/settings_repository_impl.dart';

final sl = GetIt.I;

Future<void> init() async {
  //* ##################################################################################################
  //* ### Blocs ########################################################################################
  //* ##################################################################################################
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => ConditionerBloc(conditionerRepository: sl()));
  sl.registerFactory(() => SettingsBloc(settingsRepository: sl(), databaseRepository: sl()));
  //* ##################################################################################################
  //* ### Repositories #################################################################################
  //* ##################################################################################################
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<ConditionerRepository>(() => ConditionerRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<DatabaseRepository>(() => DatabaseRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(supabase: sl()));

  final supabase = Supabase.instance.client;
  sl.registerLazySingleton(() => supabase);
}
