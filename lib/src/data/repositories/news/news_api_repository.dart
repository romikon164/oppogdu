import 'package:oppo_gdu/src/data/repositories/news/news_repository.dart';
import 'package:oppo_gdu/src/data/models/news/news.dart';
import 'package:oppo_gdu/src/http/api/api.dart';
import 'package:oppo_gdu/src/http/api/response.dart' as ApiResponse;

class NewsApiRepository extends NewsRepository
{
    Future<List<News>> fetch(int limit) async
    {
        ApiNewsRequestData request = ApiNewsRequestData.first(limit);
        ApiResponse.Response response = await Api.getInstance().retrieveNews(request);

        if(response is ApiResponse.ResponseError) {
            throw Exception("Api request error \"${response.message}\"");
        }

        return NewsCollection.fromJson(response.body["data"] as List<dynamic>).toList();
    }

    Future<List<News>> fetchAfterId(int id, int limit) async
    {
        ApiNewsRequestData request = ApiNewsRequestData.afterId(id, limit);
        ApiResponse.Response response = await Api.getInstance().retrieveNews(request);

        if(response is ApiResponse.ResponseError) {
            throw Exception("Api request error \"${response.message}\"");
        }

        return NewsCollection.fromJson(response.body["data"] as List<dynamic>).toList();
    }

    Future<News> fetchById(int id) async
    {
        ApiNewsRequestData request = ApiNewsRequestData.single(id);
        ApiResponse.Response response = await Api.getInstance().retrieveNews(request);

        if(response is ApiResponse.ResponseError) {
            throw Exception("Api request error \"${response.message}\"");
        }

        return News.fromJson(response.body["data"] as Map<String, dynamic>);
    }
}