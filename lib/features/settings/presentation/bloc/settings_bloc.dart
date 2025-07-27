import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/save_settings_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  SettingsBloc({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
  }) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    
    final result = await getSettingsUseCase(NoParams());
    
    result.fold(
      (failure) => emit(SettingsError(message: failure.message)),
      (settings) => emit(SettingsLoaded(settings: settings)),
    );
  }

  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = event.settings ?? currentSettings;
      
      emit(SettingsLoaded(settings: updatedSettings));
      
      final result = await saveSettingsUseCase(
        SaveSettingsParams(settings: updatedSettings),
      );
      
      result.fold(
        (failure) => emit(SettingsError(message: failure.message)),
        (_) => emit(SettingsLoaded(settings: updatedSettings)),
      );
    }
  }
}