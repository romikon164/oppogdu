import 'package:http/http.dart' as http;
import 'package:oppo_gdu/src/http/api/auth.dart';
import 'package:oppo_gdu/src/http/api/response.dart' as ApiResponse;
import 'dart:convert' as convert;

class Api
{
    final int clientId;

    final String clientSecret;

    final String baseUrl = 'http://api.oppo-gdu.ru';

    Auth _auth;

    static Api _instance;

    static Api buildInstance({int clientId, String clientSecret})
    {
        Api._instance = Api(clientId: clientId, clientSecret: clientSecret);

        return Api._instance;
    }

    static Api getInstance()
    {
        if(Api._instance == null) {
            throw Exception("Api not building. Call Api.buildInstance for configure interface.");
        }

        return Api._instance;
    }

    Api({this.clientId, this.clientSecret}) {
        _auth = Auth(this);
    }

    Auth get auth {
        return _auth;
    }

    Future<ApiResponse.Response> retrieveNews(ApiNewsRequestData data) async
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