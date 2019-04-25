import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

part 'auth_token.dart';
part 'response_status_codes.dart';
part 'request.dart';
part 'exceptions/request_exception.dart';
part 'exceptions/auth_invalid_credentials_exception.dart';
part 'exceptions/request_unprocessable_entity_exception.dart';
part 'exceptions/authentication_exception.dart';
part 'parameters/retrieve.dart';
part 'parameters/news_retrieve.dart';

class ApiService
{
    final int clientId;

    final String clientSecret;

    final String baseUrl;

    static ApiService _instance;

    AuthToken authToken;

    String deviceToken;

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
                'client_id': clientId.toString(),
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
            Map<String, List<String>> errors = Map<String, List<String>>();

            if(json["errors"] is Map<String, dynamic>) {
                for(String field in (json["errors"] as Map<String, dynamic>).keys) {
                    if(json["errors"][field] is List<dynamic>) {
                        errors[field] = (json["errors"][field] as List<dynamic>).map<String>((item) => item as String).toList();
                    }
                }
            }

            throw RequestUnprocessableEntityException(json["message"], errors);
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
            "$baseUrl/oauth/profile",
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

    Future<Map<String, dynamic>> retrieveNewsList(NewsRetrieveApiParameters parameters, {String deviceToken}) async
    {
        String url = "$baseUrl/news";
        String queryString = parameters.toQueryString();

        if(queryString.isNotEmpty) {
            url += "?$queryString";

            if(deviceToken != null && deviceToken.isNotEmpty) {
                url += "&auth_device_uuid=$deviceToken";
            }
        } else {
            if(deviceToken != null && deviceToken.isNotEmpty) {
                url += "?auth_device_uuid=$deviceToken";
            }
        }

        http.Response response = await http.get(
            url,
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

    Future<Map<String, dynamic>> retrieveNewsDetail(int id, String authDeviceUUID) async
    {
        String url = "$baseUrl/news/$id";

        if(authDeviceUUID != null) {
            url += '?auth_device_uuid=$authDeviceUUID';
        }
        http.Response response = await http.get(
          url,
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

    Future<Map<String, dynamic>> newsFavorite(int id, String authDeviceUUID) async
    {
        http.Response response = await http.post(
            "$baseUrl/news/$id/favorite",
            headers: {
                'Accept': 'application/json'
            },
            body: {
                'auth_device_uuid': authDeviceUUID
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

    Future<Map<String, dynamic>> newsUnFavorite(int id, String authDeviceUUID) async
    {
        http.Response response = await http.post(
            "$baseUrl/news/$id/unfavorite",
            headers: {
                'Accept': 'application/json'
            },
            body: {
                'auth_device_uuid': authDeviceUUID
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

    Future<Map<String, dynamic>> newsCounters(int id) async
    {
        http.Response response = await http.get(
            "$baseUrl/news/$id/counters",
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

    Future<Map<String, dynamic>> retrieveNewsComments(int newsId) async
    {
        http.Response response = await http.get(
            "$baseUrl/news/$newsId/comments",
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