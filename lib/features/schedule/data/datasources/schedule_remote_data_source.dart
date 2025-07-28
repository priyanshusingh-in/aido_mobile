import '../../../../core/network/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/schedule_models.dart';

abstract class ScheduleRemoteDataSource {
  Future<ScheduleResponse> createSchedule(
      CreateScheduleRequest request, String? authToken);
  Future<ScheduleListResponse> getSchedules({
    String? authToken,
    int? limit,
    int? offset,
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

      // Check if the response indicates success
      if (!response.success) {
        throw ServerException(
            message: response.error ?? 'Failed to create schedule');
      }

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduleListResponse> getSchedules({
    String? authToken,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await apiClient.getSchedules(
        authToken ?? '',
        limit,
        offset,
      );

      // Check if the response indicates success
      if (!response.success) {
        throw ServerException(
            message: response.error ?? 'Failed to get schedules');
      }

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduleResponse> getSchedule(String id, String authToken) async {
    try {
      final response = await apiClient.getSchedule(id, authToken);

      // Check if the response indicates success
      if (!response.success) {
        throw ServerException(
            message: response.error ?? 'Failed to get schedule');
      }

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduleResponse> updateSchedule(
      String id, UpdateScheduleRequest request, String authToken) async {
    try {
      final response = await apiClient.updateSchedule(id, request, authToken);

      // Check if the response indicates success
      if (!response.success) {
        throw ServerException(
            message: response.error ?? 'Failed to update schedule');
      }

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
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

      // Check if the response indicates success
      if (!response.success) {
        throw ServerException(
            message: response.error ?? 'Failed to get schedules by date range');
      }

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ScheduleListResponse> getSchedulesByType(
      String type, String authToken) async {
    try {
      final response = await apiClient.getSchedulesByType(type, authToken);

      // Check if the response indicates success
      if (!response.success) {
        throw ServerException(
            message: response.error ?? 'Failed to get schedules by type');
      }

      return response;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
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
