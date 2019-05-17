part of '../service.dart';

class VideoApiProvider
{
    final ApiService _apiService;

    VideoApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> getList() async
    {
        return await ApiRequest('videos').execute();
    }

    Future<ApiResponse> getDetail(int id) async
    {
        return await ApiRequest('videos/$id').execute();
    }
}