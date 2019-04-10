import '../repository_contract.dart';
import '../../models/model.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/news/news.dart';


class NewsApiRepository extends RepositoryContract<News>
{
    ApiService _apiService = ApiService.instance;

    Future<News> retrieve(int id) async
    {
        Map<String, dynamic> rawNews;

        try {
            rawNews = await _apiService.retrieveNewsDetail(id);
        } on RequestException catch(e) {
            if(e.code == ResponseStatusCodes.NOT_FOUND) {
                throw RepositoryNotFoundException();
            } else {
                throw e;
            }
        }

        return News.fromMap(rawNews);
    }

    Future<ModelCollection<News>> retrieveAll({int offset = 0, int limit}) async
    {
        Map<String, dynamic> rawNews = await _apiService.retrieveNewsList(page);
    }

    Future<void> persists(News model) async
    {

    }

    Future<void> persistsAll(List<News> models) async
    {

    }

    Future<void> delete(News model) async
    {

    }

    Future<void> deleteAll(List<News> models) async
    {

    }

    Future<void> update(News model) async
    {

    }

    Future<void> updateAll(List<News> models) async
    {

    }

    Future<void> truncate() async
    {

    }
}