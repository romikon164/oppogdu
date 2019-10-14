part of '../service.dart';

class PagesApiProvider
{
    final ApiService _apiService;

    PagesApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> get(String code) async
    {
        return await ApiRequest('pages/$code').execute();
    }
}