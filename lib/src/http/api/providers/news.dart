part of '../service.dart';

class NewsApiProvider
{
    final ApiService _apiService;

    NewsApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> getList([int offset = 0, limit = 15]) async
    {
        return await ApiRequest('news')
            .add("offset", offset)
            .add("limit", limit)
            .execute();
    }

    Future<ApiResponse> getListWithLeftBound(int leftBound, [int offset = 0, limit = 15]) async {
        return await ApiRequest('news')
            .add("left_bound", leftBound)
            .add("offset", offset)
            .add("limit", limit)
            .execute();
    }

    Future<ApiResponse> getListWithRightBound(int rightBound, [int offset = 0, limit = 15]) async {
        return await ApiRequest('news')
            .add("right_bound", rightBound)
            .add("offset", offset)
            .add("limit", limit)
            .execute();
    }

    Future<ApiResponse> getListWithLeftAndRightBound(int leftBound, int rightBound, [int offset = 0, limit = 15]) async {
        return await ApiRequest('news')
            .add("left_bound", leftBound)
            .add("right_bound", rightBound)
            .add("offset", offset)
            .add("limit", limit)
            .execute();
    }

    Future<ApiResponse> getDetail(int id) async
    {
        return await ApiRequest('news/$id').execute();
    }

    Future<ApiResponse> getCounters(int id) async
    {
        return await ApiRequest('news/$id/counters').execute();
    }

    Future<ApiResponse> addToFavorite(int id) async
    {
        return await ApiRequest('news/$id/favorite', ApiRequestMethod.POST).execute();
    }

    Future<ApiResponse> removeFromFavorite(int id) async
    {
        return await ApiRequest('news/$id/unfavorite', ApiRequestMethod.POST).execute();
    }

    Future<ApiResponse> getComments(int id) async
    {
        return await ApiRequest('news/$id/comments').execute();
    }

    Future<ApiResponse> sendComment(int id, String message) async
    {
        return await ApiRequest('news/$id/comments', ApiRequestMethod.POST)
            .add('content', message)
            .execute();
    }
}