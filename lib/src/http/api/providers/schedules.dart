part of '../service.dart';

class SchedulesApiProvider
{
    final ApiService _apiService;

    SchedulesApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> get(DateTime date, {int trainer, int hall}) async
    {
        print(date.millisecondsSinceEpoch ~/ 1000);
        ApiRequest apiRequest = ApiRequest('sport-complex/schedules');
        apiRequest.add('date', date.millisecondsSinceEpoch ~/ 1000);

        if (trainer != null) {
            apiRequest.add('trainer', trainer);
        }

        if (hall != null) {
            apiRequest.add('hall', hall);
        }

        return await apiRequest.execute();
    }
}