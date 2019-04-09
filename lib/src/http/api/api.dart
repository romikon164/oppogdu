import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

part 'auth.dart';
part 'response.dart';

class Api
{
    final int clientId;

    final String clientSecret;

    final String baseUrl;

    Auth _auth;

    static Api _instance;

    static Api buildInstance({int clientId, String clientSecret, String baseUrl})
    {
        Api._instance = Api(clientId: clientId, clientSecret: clientSecret, baseUrl: baseUrl);

        return Api._instance;
    }

    static Api getInstance()
    {
        if(Api._instance == null) {
            throw Exception("Api not building. Call Api.buildInstance for configure interface.");
        }

        return Api._instance;
    }

    Api({this.clientId, this.clientSecret, this.baseUrl}) {
        _auth = Auth(this);
    }

    Auth get auth {
        return _auth;
    }

    Future<Map<String, dynamic>> retrieveNews(ApiNewsRequestData data) async
    {
        String url;

        if(data.id != null) {
            url = baseUrl + "/news/${data.id}";
        } else if(data.afterId == null) {
            url = baseUrl + "/news?limit=${data.limit}";
        } else {
            url = baseUrl + "/news?after=${data.afterId}&limit=${data.limit}";
        }

        try {
            http.Response response = await http.get(url, headers: {
                "Accept": "application/json",
            });

            return ApiResponse.Response(
                code: response.statusCode,
                body: convert.jsonDecode(response.body)
            );
        } catch (exception) {
            return ApiResponse.ResponseError(exception.toString());
        }
    }
}

class ApiNewsRequestData
{
    int id;

    int afterId;

    int limit = 100;

    ApiNewsRequestData({this.id, this.afterId, this.limit});

    ApiNewsRequestData.single(this.id);

    ApiNewsRequestData.afterId(this.afterId, this.limit);

    ApiNewsRequestData.first(this.limit);
}