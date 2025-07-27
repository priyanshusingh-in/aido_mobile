import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase implements UseCase<Settings, NoParams> {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, Settings>> call(NoParams params) async {
    return await repository.getSettings();
  }
}