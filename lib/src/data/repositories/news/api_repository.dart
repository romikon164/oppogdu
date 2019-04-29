import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/news/news.dart';
import '../api_criteria.dart';


class NewsApiRepository extends RepositoryContract<News, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<News>> get(ApiCriteria criteria) async
    {
        ApiResponse apiResponse = await _apiService
            .news
            .getListWithLeftAndRightBound(
                criteria.getFilterValueByName("left_bound") as int,
                criteria.getFilterValueByName("right_bound") as int,
                criteria.getOffset(),
                criteria.getLimit()
        );

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawNewsWithMeta = apiResponse.json();
        List<dynamic> rawNewses = rawNewsWithMeta["data"] as List<dynamic>;

        return ModelCollection(News.fromList(rawNewses));
    }

    Future<News> getFirst(ApiCriteria criteria, {String deviceToken}) async
    {
        criteria.take(1);

        ModelCollection<News> newses = await get(criteria);

        if(newses.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return newses.first;
        }
    }

    Future<News> getById(int id, {String deviceToken}) async
    {
        ApiResponse apiResponse = await _apiService
            .news
            .getDetail(id);

        if(apiResponse.isNotFound) {
            throw RepositoryNotFoundException();
        }

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawNewsWithMeta = apiResponse.json();

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

    Future<void> addToFavorite(News news) async
    {
        try {
            ApiResponse apiResponse = await _apiService.news.addToFavorite(news.id);
            
            if(apiResponse.isOk) {
                Map<String, dynamic> jsonResponse = apiResponse.json();
                
                if(jsonResponse.containsKey("data")) {
                    Map<String, dynamic> jsonCounters = jsonResponse["data"] as Map<String, dynamic>;
                    
                    if(jsonCounters.containsKey("views_count")) {
                        news.viewsCount = jsonCounters["views_count"] as int;
                    }

                    if(jsonCounters.containsKey("favorites_count")) {
                        news.favoritesCount = jsonCounters["favorites_count"] as int;
                    }

                    if(jsonCounters.containsKey("comments_count")) {
                        news.commentsCount = jsonCounters["comments_count"] as int;
                    }

                    if(jsonCounters.containsKey("is_viewed")) {
                        news.isViewed = jsonCounters["is_viewed"] as bool;
                    }

                    if(jsonCounters.containsKey("is_favorited")) {
                        news.isFavorited = jsonCounters["is_favorited"] as bool;
                    }
                }
            }
        } catch(_) {
            // TODO
        }
    }

    Future<void> removeFromFavorite(News news) async
    {
        try {
            ApiResponse apiResponse = await _apiService.news.removeFromFavorite(news.id);

            if(apiResponse.isOk) {
                Map<String, dynamic> jsonResponse = apiResponse.json();

                if(jsonResponse.containsKey("data")) {
                    Map<String, dynamic> jsonCounters = jsonResponse["data"] as Map<String, dynamic>;

                    if(jsonCounters.containsKey("views_count")) {
                        news.viewsCount = jsonCounters["views_count"] as int;
                    }

                    if(jsonCounters.containsKey("favorites_count")) {
                        news.favoritesCount = jsonCounters["favorites_count"] as int;
                    }

                    if(jsonCounters.containsKey("comments_count")) {
                        news.commentsCount = jsonCounters["comments_count"] as int;
                    }

                    if(jsonCounters.containsKey("is_viewed")) {
                        news.isViewed = jsonCounters["is_viewed"] as bool;
                    }

                    if(jsonCounters.containsKey("is_favorited")) {
                        news.isFavorited = jsonCounters["is_favorited"] as bool;
                    }
                }
            }
        } catch(_) {
            // TODO
        }
    }

    Future<void> getCounters(News news) async
    {
        try {
            ApiResponse apiResponse = await _apiService.news.getCounters(news.id);

            if(apiResponse.isOk) {
                Map<String, dynamic> jsonResponse = apiResponse.json();

                if(jsonResponse.containsKey("data")) {
                    Map<String, dynamic> jsonCounters = jsonResponse["data"] as Map<String, dynamic>;

                    if(jsonCounters.containsKey("views_count")) {
                        news.viewsCount = jsonCounters["views_count"] as int;
                    }

                    if(jsonCounters.containsKey("favorites_count")) {
                        news.favoritesCount = jsonCounters["favorites_count"] as int;
                    }

                    if(jsonCounters.containsKey("comments_count")) {
                        news.commentsCount = jsonCounters["comments_count"] as int;
                    }

                    if(jsonCounters.containsKey("is_viewed")) {
                        news.isViewed = jsonCounters["is_viewed"] as bool;
                    }

                    if(jsonCounters.containsKey("is_favorited")) {
                        news.isFavorited = jsonCounters["is_favorited"] as bool;
                    }
                }
            }
        } catch (_) {

        }
    }
}