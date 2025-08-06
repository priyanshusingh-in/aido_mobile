import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../constants/api_constants.dart';
import '../network/api_client.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../utils/notification_utils.dart';
import '../utils/secure_storage_service.dart';

// Auth
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_user_profile_usecase.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Schedule
import '../../features/schedule/data/datasources/schedule_local_data_source.dart';
import '../../features/schedule/data/datasources/schedule_remote_data_source.dart';
import '../../features/schedule/data/repositories/schedule_repository_impl.dart';
import '../../features/schedule/domain/repositories/schedule_repository.dart';
import '../../features/schedule/domain/usecases/create_schedule_usecase.dart';
import '../../features/schedule/domain/usecases/get_schedules_usecase.dart';
import '../../features/schedule/domain/usecases/update_schedule_usecase.dart';
import '../../features/schedule/domain/usecases/delete_schedule_usecase.dart';
import '../../features/schedule/presentation/bloc/schedule_bloc.dart';

// Settings
import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings_usecase.dart';
import '../../features/settings/domain/usecases/save_settings_usecase.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => const FlutterSecureStorage());
  getIt.registerLazySingleton(() => InternetConnectionChecker());

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton(() => DioClient(getIt()));
  getIt.registerLazySingleton(
      () => ApiClient(getIt<DioClient>().dio, baseUrl: ApiConstants.baseUrl));
  getIt.registerLazySingleton(() => SecureStorageService());

  // Initialize notifications
  // TODO: Temporarily disabled due to icon resource issue
  // try {
  //   await NotificationUtils.initialize();
  // } catch (e) {
  //   // Temporarily disable notifications if initialization fails
  //   print('Warning: Notification initialization failed: $e');
  // }

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckAuthStatusUseCase(getIt()));
  getIt.registerFactory(() => AuthBloc(
        loginUseCase: getIt(),
        registerUseCase: getIt(),
        logoutUseCase: getIt(),
        getUserProfileUseCase: getIt(),
        checkAuthStatusUseCase: getIt(),
      ));

  // Schedule
  getIt.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ScheduleLocalDataSource>(
    () => ScheduleLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => CreateScheduleUseCase(getIt()));
  getIt.registerLazySingleton(() => GetSchedulesUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateScheduleUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteScheduleUseCase(getIt()));
  getIt.registerFactory(() => ScheduleBloc(
        createScheduleUseCase: getIt(),
        getSchedulesUseCase: getIt(),
        updateScheduleUseCase: getIt(),
        deleteScheduleUseCase: getIt(),
      ));

  // Settings
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetSettingsUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveSettingsUseCase(getIt()));
  getIt.registerFactory(() => SettingsBloc(
        getSettingsUseCase: getIt(),
        saveSettingsUseCase: getIt(),
      ));
}
