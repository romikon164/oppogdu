part of '../service.dart';

class TrainersApiProvider
{
    final ApiService _apiService;

    TrainersApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> get() async
    {
        return await ApiRequest('sport-complex/trainers').execute();
    }
}