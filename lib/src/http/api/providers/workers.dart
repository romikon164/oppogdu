part of '../service.dart';

class WorkerApiProvider
{
    final ApiService _apiService;

    WorkerApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> getList() async
    {
        return await ApiRequest('workers').execute();
    }

    Future<ApiResponse> getDetail(int id) async
    {
        return await ApiRequest('workers/$id').execute();
    }

    Future<ApiResponse> getLeadershipsList() async
    {
        return await ApiRequest('workers/leaderships').execute();
    }

    Future<ApiResponse> getTrainersList() async
    {
        return await ApiRequest('workers/trainers').execute();
    }
}