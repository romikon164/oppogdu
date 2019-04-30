part of '../service.dart';

class ContactsApiProvider
{
    final ApiService _apiService;

    ContactsApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> getCompanyContacts() async
    {
        return ApiRequest('contacts', ApiRequestMethod.GET).execute();
    }
}