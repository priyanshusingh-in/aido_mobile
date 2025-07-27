import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class SaveSettingsUseCase implements UseCase<void, SaveSettingsParams> {
  final SettingsRepository repository;

  SaveSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveSettingsParams params) async {
    return await repository.saveSettings(params.settings);
  }
}

class SaveSettingsParams extends Equatable {
  final Settings settings;

  const SaveSettingsParams({required this.settings});

  @override
  List<Object> get props => [settings];
}