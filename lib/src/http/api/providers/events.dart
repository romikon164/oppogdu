part of '../service.dart';

class EventApiProvider
{
    final ApiService _apiService;

    EventApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> getList() async
    {
        return await ApiRequest('sport-complex/events').execute();
    }

    Future<ApiResponse> getDetail(int id) async
    {
        return await ApiRequest('sport-complex/events/$id').execute();
    }
}