import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/schedule_repository.dart';

class DeleteScheduleUseCase implements UseCase<void, DeleteScheduleParams> {
  final ScheduleRepository repository;

  DeleteScheduleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteScheduleParams params) async {
    return await repository.deleteSchedule(
      id: params.id,
      authToken: params.authToken,
    );
  }
}

class DeleteScheduleParams extends Equatable {
  final String id;
  final String authToken;

  const DeleteScheduleParams({
    required this.id,
    required this.authToken,
  });

  @override
  List<Object> get props => [id, authToken];
}