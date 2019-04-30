part of '../service.dart';

class PhotoApiProvider
{
    final ApiService _apiService;

    PhotoApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> getList() async
    {
        return await ApiRequest('photo-albums').execute();
    }

    Future<ApiResponse> getDetail(int id) async
    {
        print('photo-albums/$id');
        return await ApiRequest('photo-albums/$id').execute();
    }

    Future<ApiResponse> getCounters(int id) async
    {
        return await ApiRequest('photos/$id/counters').execute();
    }

    Future<ApiResponse> addToFavorite(int id) async
    {
        print('photos/$id/favorite');
        return await ApiRequest('photos/$id/favorite', ApiRequestMethod.POST).execute();
    }

    Future<ApiResponse> removeFromFavorite(int id) async
    {
        return await ApiRequest('photos/$id/unfavorite', ApiRequestMethod.POST).execute();
    }
}