import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/schedule_models.dart';

abstract class ScheduleLocalDataSource {
  Future<void> cacheSchedules(List<ScheduleModel> schedules);
  Future<List<ScheduleModel>> getCachedSchedules();
  Future<void> cacheSchedule(ScheduleModel schedule);
  Future<ScheduleModel?> getCachedSchedule(String id);
  Future<void> removeCachedSchedule(String id);
  Future<void> clearCache();
}

class ScheduleLocalDataSourceImpl implements ScheduleLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String schedulesKey = 'cached_schedules';

  ScheduleLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheSchedules(List<ScheduleModel> schedules) async {
    try {
      final schedulesJson =
          schedules.map((schedule) => schedule.toJson()).toList();
      await sharedPreferences.setString(
          schedulesKey, jsonEncode(schedulesJson));
    } catch (e) {
      throw const CacheException(message: 'Failed to cache schedules');
    }
  }

  @override
  Future<List<ScheduleModel>> getCachedSchedules() async {
    try {
      final schedulesJson = sharedPreferences.getString(schedulesKey);
      if (schedulesJson != null) {
        final schedulesList = jsonDecode(schedulesJson) as List;
        return schedulesList
            .map((json) => ScheduleModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw const CacheException(message: 'Failed to get cached schedules');
    }
  }

  @override
  Future<void> cacheSchedule(ScheduleModel schedule) async {
    try {
      final cachedSchedules = await getCachedSchedules();
      final existingIndex =
          cachedSchedules.indexWhere((s) => s.id == schedule.id);

      if (existingIndex != -1) {
        cachedSchedules[existingIndex] = schedule;
      } else {
        cachedSchedules.add(schedule);
      }

      await cacheSchedules(cachedSchedules);
    } catch (e) {
      throw const CacheException(message: 'Failed to cache schedule');
    }
  }

  @override
  Future<ScheduleModel?> getCachedSchedule(String id) async {
    try {
      final cachedSchedules = await getCachedSchedules();
      return cachedSchedules.firstWhere(
        (schedule) => schedule.id == id,
        orElse: () =>
            throw const CacheException(message: 'Schedule not found in cache'),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> removeCachedSchedule(String id) async {
    try {
      final cachedSchedules = await getCachedSchedules();
      cachedSchedules.removeWhere((schedule) => schedule.id == id);
      await cacheSchedules(cachedSchedules);
    } catch (e) {
      throw const CacheException(message: 'Failed to remove cached schedule');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(schedulesKey);
    } catch (e) {
      throw const CacheException(message: 'Failed to clear cache');
    }
  }
}
