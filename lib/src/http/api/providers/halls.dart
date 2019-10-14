part of '../service.dart';

class HallsApiProvider
{
    final ApiService _apiService;

    HallsApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> get() async
    {
        return await ApiRequest('sport-complex/halls').execute();
    }
}