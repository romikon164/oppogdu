import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

part 'auth_token.dart';
part 'response_status_codes.dart';
part 'request.dart';
part 'exceptions/request_exception.dart';
part 'exceptions/auth_invalid_credentials_exception.dart';
part 'exceptions/request_unprocessable_entity_exception.dart';
part 'exceptions/authentication_exception.dart';

class ApiService
{
    final int clientId;

    final String clientSecret;

    final String baseUrl;

    static ApiService _instance;

    AuthToken authToken;

    static ApiService buildInstance({int clientId, String clientSecret, String baseUrl})
    {
        ApiService._instance = ApiService(clientId: clientId, clientSecret: clientSecret, baseUrl: baseUrl);

        return ApiService._instance;
    }

    static ApiService get instance
    {
        if(ApiService._instance == null) {
            throw Exception("Api not building. Call Api.buildInstance for configure interface.");
        }

        return ApiService._instance;
    }

    ApiService({this.clientId, this.clientSecret, this.baseUrl});

    Future<AuthToken> createAccount({String email, String phone, String password, String fullname}) async
    {
        http.Response response = await http.post(
            "$baseUrl/oauth/register",
            headers: {
                'Accept': 'application/json',
            },
            body: {
                'client_id': clientId,
                'client_secret': clientSecret,
                'grant_type': 'password',
                'email': email,
                'password': password,
                'phone': phone,
                'full_name': fullname
            }
        );

        if(response.statusCode == ResponseStatusCodes.UNPROCESSABLE_ENTITY) {
            Map<String, dynamic> json = convert.jsonDecode(response.body);
            throw RequestUnprocessableEntityException(json["message"], json["erros"]);
        } else if(response.statusCode != ResponseStatusCodes.OK) {
            throw RequestException(
              response.statusCode,
              "ApiService.requestToken http request exception"
            );
        }

        Map<String, dynamic> json = convert.jsonDecode(response.body);

        return AuthToken(
            type: json["token_type"],
            accessToken: json["access_token"],
            refreshToken: json["refresh_token"],
            expiresIn: json["expires_in"],
        );
    }

    Future<AuthToken> requestToken(String username, String password) async {
        http.Response response = await http.post(
            "$baseUrl/oauth/token",
            headers: {
                'Accept': 'application/json',
            },
            body: {
                'client_id': clientId.toString(),
                'client_secret': clientSecret,
                'grant_type': 'password',
                'username': username,
                'password': password,
            }
        );

        if(response.statusCode == ResponseStatusCodes.UNAUTHORIZED) {
            throw AuthInvalidCredentialsException();
        } else if(response.statusCode != ResponseStatusCodes.OK) {
            throw RequestException(
                response.statusCode,
                "ApiService.requestToken http request exception"
            );
        }

        Map<String, dynamic> json = convert.jsonDecode(response.body);

        return AuthToken(
            type: json["token_type"],
            accessToken: json["access_token"],
            refreshToken: json["refresh_token"],
            expiresIn: json["expires_in"],
        );
    }

    Future<Map<String, dynamic>> retrieveUserProfile() async
    {
        if(authToken == null) {
            throw AuthenticationException();
        }

        http.Response response = await http.get(
            "$baseUrl/profile",
            headers: {
                'Accept': 'application/json',
                'Authorization': "Bearer ${authToken.accessToken}"
            }
        );

        if(response.statusCode == ResponseStatusCodes.UNAUTHORIZED) {
            throw AuthenticationException();
        } else if(response.statusCode != ResponseStatusCodes.OK) {
            throw RequestException(
                response.statusCode,
                "ApiService.requestToken http request exception"
            );
        }

        return convert.jsonDecode(response.body);
    }

    Future<Map<String, dynamic>> retrieveNewsList(int page) async
    {
        http.Response response = await http.get(
            "$baseUrl/news?page=$page",
            headers: {
                'Accept': 'application/json'
            }
        );

        if(response.statusCode != ResponseStatusCodes.OK) {
            throw RequestException(
                response.statusCode,
                "ApiService.requestToken http request exception"
            );
        }

        return convert.jsonDecode(response.body);
    }

    Future<Map<String, dynamic>> retrieveNewsDetail(int id) async
    {
        http.Response response = await http.get(
          "$baseUrl/news/$id",
          headers: {
              'Accept': 'application/json'
          }
        );

        if(response.statusCode != ResponseStatusCodes.OK) {
            throw RequestException(
              response.statusCode,
              "ApiService.requestToken http request exception"
            );
        }

        return convert.jsonDecode(response.body);
    }
}