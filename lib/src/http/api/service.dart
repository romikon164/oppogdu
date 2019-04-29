import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:http_parser/http_parser.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';

part 'auth_token.dart';
part 'response.dart';
part 'response_status_codes.dart';
part 'request.dart';
part 'exceptions/request_exception.dart';
part 'exceptions/auth_invalid_credentials_exception.dart';
part 'exceptions/request_unprocessable_entity_exception.dart';
part 'exceptions/request_invalid_body.dart';
part 'exceptions/authentication_exception.dart';
part 'parameters/retrieve.dart';
part 'parameters/news_retrieve.dart';
part 'providers/news.dart';
part 'providers/photos.dart';

class ApiService
{
    final int clientId;

    final String clientSecret;

    final String baseUrl;

    static ApiService _instance;

    AuthToken authToken;

    String deviceToken;

    NewsApiProvider _newsApiProvider;

    NewsApiProvider get news => _newsApiProvider;

    PhotoApiProvider _photoApiProvider;

    PhotoApiProvider get photos => _photoApiProvider;

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

    ApiService({this.clientId, this.clientSecret, this.baseUrl}) {
        _newsApiProvider = NewsApiProvider(this);
        _photoApiProvider = PhotoApiProvider(this);
    }

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

    Future<ApiResponse> request(ApiRequest apiRequest) async
    {
        if(apiRequest.hasMultiPart()) {
            return await _multiPartRequest(apiRequest);
        }

        String url = _getMethodUrl(apiRequest.method);

        Map<String, String> _headers = apiRequest._headers;

        _headers["Accept"] = "application/json";

        if(authToken != null) {
            _headers['Authorization'] = "Bearer ${authToken.accessToken}";
        }

        if(AuthService.instance.firebaseToken != null) {
            _headers['X-Device-Token'] = AuthService.instance.firebaseToken;
        }

        http.Response response;

        if(apiRequest.requestMethod == ApiRequestMethod.GET) {
            url += '?' + apiRequest.bodyToQueryString();

            response = await http.get(url, headers: _headers);
        } else if(apiRequest.requestMethod == ApiRequestMethod.POST) {
            response = await http.post(url, headers: _headers, body: apiRequest._data);
        } else if(apiRequest.requestMethod == ApiRequestMethod.PUT) {
            response = await http.put(url, headers: _headers, body: apiRequest._data);
        } else if(apiRequest.requestMethod == ApiRequestMethod.PATCH) {
            response = await http.patch(url, headers: _headers, body: apiRequest._data);
        } else if(apiRequest.requestMethod == ApiRequestMethod.DELETE) {
            url += '?' + apiRequest.bodyToQueryString();

            response = await http.delete(url, headers: _headers);
        } else {
            // TODO
        }

        return ApiResponse(response.statusCode, response.body);
    }

    Future<ApiResponse> _multiPartRequest(ApiRequest apiRequest) async
    {
        String method = "POST";
        String url = _getMethodUrl(apiRequest.method);

        if(apiRequest.requestMethod == ApiRequestMethod.GET) {
            method = "GET";
            url += '?' + apiRequest.bodyToQueryString();
        } else if(apiRequest.requestMethod == ApiRequestMethod.POST) {
            method = "POST";
        } else if(apiRequest.requestMethod == ApiRequestMethod.PUT) {
            method = "PUT";
        } else if(apiRequest.requestMethod == ApiRequestMethod.PATCH) {
            method = "PATCH";
        } else if(apiRequest.requestMethod == ApiRequestMethod.DELETE) {
            method = "DELETE";
            url += '?' + apiRequest.bodyToQueryString();
        } else {
            // TODO
        }

        http.MultipartRequest request = http.MultipartRequest(method, Uri.parse(url));
        
        for(String field in apiRequest._data.keys) {
            dynamic value = apiRequest._data[field];
            
            if(value is ApiMultiPartData) {
                http.MultipartFile file = http.MultipartFile.fromBytes(
                    value.name,
                    value.data,
                    filename: value.filename,
                    contentType: MediaType.parse(value.contentType)
                );
                request.files.add(file);
            } else if(value is int) {
                request.fields[field] = "$value";
            } else if(value is double) {
                request.fields[field] = "$value";
            } else if(value is bool) {
                request.fields[field] = value ? "true" : "false";
            } else {
                request.fields[field] = value;
            }
        }

        request.headers["Accept"] = "application/json";

        if(authToken != null) {
            request.headers['Authorization'] = "Bearer ${authToken.accessToken}";
        }

        if(AuthService.instance.firebaseToken != null) {
            request.headers['X-Device-Token'] = AuthService.instance.firebaseToken;
        }

        http.Response response = await http.Response.fromStream(await request.send());

        return ApiResponse(response.statusCode, response.body);
    }

    String _getMethodUrl(String method)
    {
        String _baseUrl = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
        String _method = method.startsWith("/") ? method.substring(1, method.length - 1) : method;

        return "$_baseUrl/$_method";
    }
}