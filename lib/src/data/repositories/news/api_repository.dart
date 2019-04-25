import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/news/news.dart';
import '../api_criteria.dart';


class NewsApiRepository extends RepositoryContract<News, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<News>> get(ApiCriteria criteria, {String deviceToken}) async
    {
        NewsRetrieveApiParameters parameters = NewsRetrieveApiParameters(
            offset: criteria.getOffset(),
            limit: criteria.getLimit(),
            sortBy: criteria.getSortBy(),
            sortDir: criteria.getSortDirection(),
            leftBound: criteria.getFilterValueByName("left_bound") as int,
            rightBound: criteria.getFilterValueByName("right_bound") as int,
        );

        Map<String, dynamic> rawNewsWithMeta = await _apiService.retrieveNewsList(parameters, deviceToken: deviceToken);

        List<dynamic> rawNewses = rawNewsWithMeta["data"] as List<dynamic>;

        return ModelCollection(News.fromList(rawNewses));
    }

    Future<News> getFirst(ApiCriteria criteria, {String deviceToken}) async
    {
        criteria.take(1);

        ModelCollection<News> newses = await get(criteria, deviceToken: deviceToken);

        if(newses.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return newses.first;
        }
    }

    Future<News> getById(int id, {String deviceToken}) async
    {
        Map<String, dynamic> rawNewsWithMeta = await _apiService.retrieveNewsDetail(id, deviceToken);

        if(!rawNewsWithMeta.containsKey("data")) {
            throw RepositoryNotFoundException();
        }

        Map<String, dynamic> rawNews = rawNewsWithMeta["data"] as Map<String, dynamic>;

        return News.fromMap(rawNews);
    }

    Future<bool> add(News news) async
    {
        return false;
    }

    Future<bool> delete(News model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(News model) async
    {
        return false;
    }

    Future<bool> addToFavorite(int id, String deviceToken) async
    {
        try {
            await _apiService.newsFavorite(id, deviceToken);
            return true;
        } catch(_) {
            return false;
        }
    }

    Future<bool> removeFromFavorite(int id, String deviceToken) async
    {
        try {
            await _apiService.newsUnFavorite(id, deviceToken);
            return true;
        } catch(_) {
            return false;
        }
    }

    Future<bool> getCounters(News news) async
    {
        try {
            Map<String, dynamic> counters = await _apiService.newsCounters(news.id);

            if(counters.containsKey("data")) {
                counters = counters["data"] as Map<String, dynamic>;

                if (counters.containsKey("favorites_count")) {
                    news.favoritesCount = counters["favorites_count"] as int;
                }

                if (counters.containsKey("views_count")) {
                    news.viewsCount = counters["views_count"] as int;
                }

                if (counters.containsKey("comments_count")) {
                    news.commentsCount = counters["comments_count"] as int;
                }
            }

            return true;
        } catch (e) {
            return false;
        }
    }
}