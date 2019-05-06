part of '../service.dart';

class OrganizationApiProvider
{
    final ApiService _apiService;

    OrganizationApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> getList() async
    {
        return await ApiRequest('organizations').execute();
    }

    Future<ApiResponse> getDetail(int id) async
    {
        return await ApiRequest('organizations/$id').execute();
    }
}