import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/schedule_models.dart';

abstract class ScheduleRemoteDataSource {
  Future<ScheduleResponse> createSchedule(
      CreateScheduleRequest request, String? authToken);
  Future<ScheduleListResponse> getSchedules({
    String? authToken,
    int? page,
    int? limit,
    String? type,
    String? priority,
    String? date,
  });
  Future<ScheduleResponse> getSchedule(String id, String authToken);
  Future<ScheduleResponse> updateSchedule(
      String id, UpdateScheduleRequest request, String authToken);
  Future<void> deleteSchedule(String id, String authToken);
  Future<ScheduleListResponse> getSchedulesByDateRange(
      String startDate, String endDate, String authToken);
  Future<ScheduleListResponse> getSchedulesByType(
      String type, String authToken);
  Future<Map<String, dynamic>> healthCheck();
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final ApiClient apiClient;

  ScheduleRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ScheduleResponse> createSchedule(
      CreateScheduleRequest request, String? authToken) async {
    try {
      final response = await apiClient.createSchedule(request, authToken);
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduleListResponse> getSchedules({
    String? authToken,
    int? page,
    int? limit,
    String? type,
    String? priority,
    String? date,
  }) async {
    try {
      final response = await apiClient.getSchedules(
        authToken ?? '',
        page,
        limit,
        type,
        priority,
        date,
      );
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduleResponse> getSchedule(String id, String authToken) async {
    try {
      final response = await apiClient.getSchedule(id, authToken);
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduleResponse> updateSchedule(
      String id, UpdateScheduleRequest request, String authToken) async {
    try {
      final response = await apiClient.updateSchedule(id, request, authToken);
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteSchedule(String id, String authToken) async {
    try {
      await apiClient.deleteSchedule(id, authToken);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduleListResponse> getSchedulesByDateRange(
      String startDate, String endDate, String authToken) async {
    try {
      final response = await apiClient.getSchedulesByDateRange(
          startDate, endDate, authToken);
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduleListResponse> getSchedulesByType(
      String type, String authToken) async {
    try {
      final response = await apiClient.getSchedulesByType(type, authToken);
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await apiClient.healthCheck();
      return response;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
