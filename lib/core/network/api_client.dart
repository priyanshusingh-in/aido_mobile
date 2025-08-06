import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../constants/api_constants.dart';
import '../../features/auth/data/models/auth_models.dart';
import '../../features/schedule/data/models/schedule_models.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

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
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );

  @GET(ApiConstants.scheduleById)
  Future<ScheduleResponse> getSchedule(
    @Path('id') String id,
    @Header(ApiConstants.authorization) String token,
  );

  @PUT(ApiConstants.scheduleById)
  Future<ScheduleResponse> updateSchedule(
    @Path('id') String id,
    @Body() UpdateScheduleRequest request,
    @Header(ApiConstants.authorization) String token,
  );

  @DELETE(ApiConstants.scheduleById)
  Future<void> deleteSchedule(
    @Path('id') String id,
    @Header(ApiConstants.authorization) String token,
  );

  // Additional schedule endpoints
  @GET(ApiConstants.scheduleByDateRange)
  Future<ScheduleListResponse> getSchedulesByDateRange(
    @Query('startDate') String startDate,
    @Query('endDate') String endDate,
    @Header(ApiConstants.authorization) String token,
  );

  @GET(ApiConstants.scheduleByType)
  Future<ScheduleListResponse> getSchedulesByType(
    @Path('type') String type,
    @Header(ApiConstants.authorization) String token,
  );

  // System endpoints
  @GET(ApiConstants.health)
  Future<dynamic> healthCheck();
}
