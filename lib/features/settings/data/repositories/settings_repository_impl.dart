import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      final settings = await localDataSource.getSettings();
      return Right(settings);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(Settings settings) async {
    try {
      final settingsModel = SettingsModel.fromEntity(settings);
      await localDataSource.saveSettings(settingsModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}