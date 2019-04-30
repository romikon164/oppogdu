part of '../service.dart';

class OrderApiProvider
{
    final ApiService _apiService;

    OrderApiProvider(this._apiService);

    ApiService get apiService => _apiService;

    Future<ApiResponse> send({String subject, String message, String phone, String email}) async
    {
        ApiRequest apiRequest = ApiRequest('orders', ApiRequestMethod.POST)
            .add('subject', subject)
            .add('message', message);

        if(email != null) {
            apiRequest.add('email', email);
        }

        if(phone != null) {
            apiRequest.add('phone', phone);
        }

        return await apiRequest.execute();
    }
}