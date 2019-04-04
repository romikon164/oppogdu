import 'package:http/http.dart' as http;
import 'package:oppo_gdu/src/http/api/response.dart' as ApiResponse;
import 'package:oppo_gdu/src/http/api/api.dart';
import 'dart:convert' as convert;

class Auth
{
    final Api api;

    Auth(this.api);

    Future<ApiResponse.Response> createAccount(AuthCreateAccountData data) async
    {
        try {
            http.Response response = await http.post(
                api.baseUrl + '/oauth/register',
                headers: {
                    'Accept': 'application/json',
                },
                body: {
                    'client_id': api.clientId,
                    'client_secret': api.clientSecret,
                    'grant_type': 'password',
                    'email': data.email,
                    'password': data.password,
                    'phone': data.phone,
                    'full_name': data.fullname
                }
            );

            return ApiResponse.Response(
                code: response.statusCode,
                body: convert.jsonDecode(response.body)
            );
        } catch (exception) {
            return ApiResponse.ResponseError(exception.toString());
        }
    }

    Future<ApiResponse.Response> requestToken(AuthRequestTokenData data) async
    {
        try {
            http.Response response = await http.post(
                api.baseUrl + '/oauth/register',
                headers: {
                    'Accept': 'application/json',
                },
                body: {
                    'client_id': api.clientId,
                    'client_secret': api.clientSecret,
                    'grant_type': 'password',
                    'username': data.username,
                    'password': data.password,
                }
            );

            return ApiResponse.Response(
                code: response.statusCode,
                body: convert.jsonDecode(response.body)
            );
        } catch (exception) {
            return ApiResponse.ResponseError(exception.toString());
        }
    }


}

class AuthCreateAccountData
{
    String email;

    String phone;

    String password;

    String fullname;

    AuthCreateAccountData({this.email, this.phone, this.password, this.fullname});
}

class AuthRequestTokenData
{
    String username;

    String password;

    AuthRequestTokenData({this.username, this.password});
}

class AuthToken
{
    AuthTokenType tokenType;

    DateTime expiresIn;

    String accessToken;

    String refreshToken;

    AuthToken({this.tokenType = AuthTokenType.Bearer, this.expiresIn, this.accessToken, this.refreshToken});

    factory AuthToken.fromJson(Map<String, dynamic> json)
    {
        int expiresInSeconds = json["expires_in"] as int;

        return AuthToken(
            expiresIn: DateTime.fromMillisecondsSinceEpoch(expiresInSeconds * 1000),
            accessToken: json["access_token"] as String,
            refreshToken: json["refresh_token"] as String,
        );
    }
}

enum AuthTokenType
{
    Bearer
}