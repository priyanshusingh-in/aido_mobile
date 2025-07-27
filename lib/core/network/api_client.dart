import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../constants/api_constants.dart';
import '../../features/auth/data/models/auth_models.dart';
import '../../features/schedule/data/models/schedule_models.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Auth endpoints
  @POST(ApiConstants.login)
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST(ApiConstants.register)
  Future<AuthResponse> register(@Body() RegisterRequest request);

  @GET(ApiConstants.profile)
  Future<UserResponse> getProfile(
      @Header(ApiConstants.authorization) String token);

  // Schedule endpoints
  @POST(ApiConstants.createSchedule)
  Future<ScheduleResponse> createSchedule(
    @Body() CreateScheduleRequest request,
    @Header(ApiConstants.authorization) String? token,
  );

  @GET(ApiConstants.schedules)
  Future<ScheduleListResponse> getSchedules(
    @Header(ApiConstants.authorization) String token,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('type') String? type,
    @Query('priority') String? priority,
    @Query('date') String? date,
  );

  @GET('${ApiConstants.schedules}/{id}')
  Future<ScheduleResponse> getSchedule(
    @Path('id') String id,
    @Header(ApiConstants.authorization) String token,
  );

  @PUT('${ApiConstants.schedules}/{id}')
  Future<ScheduleResponse> updateSchedule(
    @Path('id') String id,
    @Body() UpdateScheduleRequest request,
    @Header(ApiConstants.authorization) String token,
  );

  @DELETE('${ApiConstants.schedules}/{id}')
  Future<void> deleteSchedule(
    @Path('id') String id,
    @Header(ApiConstants.authorization) String token,
  );

  // Additional schedule endpoints
  @GET('${ApiConstants.schedules}/date-range')
  Future<ScheduleListResponse> getSchedulesByDateRange(
    @Query('startDate') String startDate,
    @Query('endDate') String endDate,
    @Header(ApiConstants.authorization) String token,
  );

  @GET('${ApiConstants.schedules}/type/{type}')
  Future<ScheduleListResponse> getSchedulesByType(
    @Path('type') String type,
    @Header(ApiConstants.authorization) String token,
  );

  // System endpoints
  @GET('/health')
  Future<Map<String, dynamic>> healthCheck();
}
