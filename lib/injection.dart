import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '2_application/auth/auth_bloc.dart';
import '2_application/branch_detail/branch_detail_bloc.dart';
import '2_application/branches_overview/branches_overview_bloc.dart';
import '2_application/categories_overview/categories_overview_bloc.dart';
import '2_application/conditioner_detail/conditioner_detail_bloc.dart';
import '2_application/conditioners_overview/conditioners_overview_bloc.dart';
import '2_application/customer_detail/customer_detail_bloc.dart';
import '2_application/customers_overview/customers_overview_bloc.dart';
import '2_application/purchace/purchace_bloc.dart';
import '2_application/service_detail/service_detail_bloc.dart';
import '2_application/services_overview/services_overview_bloc.dart';
import '2_application/settings/settings_bloc.dart';
import '2_application/template_services/template_services_bloc.dart';
import '3_domain/repositories/auth_repository.dart';
import '3_domain/repositories/branch_repository.dart';
import '3_domain/repositories/category_repository.dart';
import '3_domain/repositories/conditioner_repository.dart';
import '3_domain/repositories/customer_repository.dart';
import '3_domain/repositories/database_repository.dart';
import '3_domain/repositories/service_repository.dart';
import '3_domain/repositories/settings_repository.dart';
import '3_domain/repositories/template_service_repository.dart';
import '4_infrastructur/auth_repository_impl.dart';
import '4_infrastructur/branch_repository_impl.dart';
import '4_infrastructur/category_repository_impl.dart';
import '4_infrastructur/conditioner_repository_impl.dart';
import '4_infrastructur/customer_repository_impl.dart';
import '4_infrastructur/database_repository_impl.dart';
import '4_infrastructur/service_repository_impl.dart';
import '4_infrastructur/settings_repository_impl.dart';
import '4_infrastructur/template_service_repository_impl.dart';

final sl = GetIt.I;

Future<void> init() async {
  //* ##################################################################################################
  //* ### Blocs ########################################################################################
  //* ##################################################################################################
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => ConditionersOverviewBloc(conditionerRepository: sl()));
  sl.registerFactory(() => ConditionerDetailBloc(conditionerRepository: sl()));
  sl.registerFactory(() => CustomersOverviewBloc(customerRepository: sl()));
  sl.registerFactory(() => CustomerDetailBloc(customerRepository: sl()));
  sl.registerFactory(() => BranchesOverviewBloc(branchRepository: sl()));
  sl.registerFactory(() => ServicesOverviewBloc(serviceRepository: sl()));
  sl.registerFactory(() => ServiceDetailBloc(serviceRepository: sl(), databaseRepository: sl()));
  sl.registerFactory(() => CategoriesOverviewBloc(categoryRepository: sl()));
  sl.registerFactory(() => TemplateServicesBloc(templateServiceRepository: sl()));
  sl.registerFactory(() => BranchDetailBloc(branchRepository: sl()));
  sl.registerFactory(() => SettingsBloc(settingsRepository: sl(), databaseRepository: sl()));
  sl.registerLazySingleton(() => PurchaceBloc());
  //* ##################################################################################################
  //* ### Repositories #################################################################################
  //* ##################################################################################################
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<ConditionerRepository>(() => ConditionerRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<DatabaseRepository>(() => DatabaseRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<BranchRepository>(() => BranchRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<ServiceRepository>(() => ServiceRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<TemplateServiceRepository>(() => TemplateServiceRepositoryImpl(supabase: sl()));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(supabase: sl()));

  final supabase = Supabase.instance.client;
  sl.registerLazySingleton(() => supabase);
}
