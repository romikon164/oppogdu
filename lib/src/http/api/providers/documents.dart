part of '../service.dart';

class DocumentApiProvider
{
    final ApiService _apiService;

    DocumentApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> getList() async
    {
        return await ApiRequest('documents').execute();
    }

    Future<ApiResponse> getDetail(int id) async
    {
        return await ApiRequest('documents/$id').execute();
    }

    Future<ApiResponse> getPrintList() async
    {
        return await ApiRequest('documents/prints').execute();
    }

    Future<ApiResponse> getActList() async
    {
        return await ApiRequest('documents/acts').execute();
    }
}