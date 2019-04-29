import '../database_repository_contract.dart';
import '../../models/news/news.dart';
import '../../database/service.dart';
import '../../database/providers/news.dart';
import '../../models/model_collection.dart';
import '../exceptions/not_found.dart';
import '../database_criteria.dart';
import '../criteria.dart';
import 'dart:convert' as convert;

class NewsDatabaseRepository extends DatabaseRepositoryContract<News>
{
    NewsDatabaseProvider _newsProvider;

    NewsDatabaseRepository(): super();

    NewsDatabaseProvider get provider => _newsProvider;

    Future<void> _initRepository() async
    {
        _newsProvider = await DatabaseService.instance.getDatabaseProvider("news");
    }

    Future<bool> add(News news) async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        try {
            Map<String, dynamic> rawNews = news.toMap();

            if(rawNews.containsKey("content") && rawNews["content"] is List<dynamic>) {
                rawNews["content"] = convert.jsonEncode(rawNews["content"]);
            }

            int id = await _newsProvider.persists(rawNews);
            if(news.id == null) {
                news.id = id;
            }

            return true;
        } catch(_) {
            return false;
        }
    }

    Future<ModelCollection<News>> get(CriteriaContract criteria) async
    {
        DatabaseCriteria databaseCriteria = criteria as DatabaseCriteria;

        if(_newsProvider == null) {
            await _initRepository();
        }

        List<Map<String, dynamic>> rawNewses = (await _newsProvider.retrieve(
            where: databaseCriteria.getWhere(),
            orderBy: databaseCriteria.getSort(),
            offset: databaseCriteria.getOffset(),
            limit: databaseCriteria.getLimit()
        )).map((item) {
            Map<String, dynamic> newItem = Map<String, dynamic>.from(item);

            if(item.containsKey("is_viewed") && item["is_viewed"] != null) {
                newItem["is_viewed"] = item["is_viewed"] != 0;
            }

            if(item.containsKey("is_favorited") && item["is_favorited"] != null) {
                newItem["is_favorited"] = item["is_favorited"] != 0;
            }

            return newItem;
        }).toList();

        return ModelCollection<News>(
            rawNewses.map<News>((news) => News.fromMap(news)).toList()
        );
    }

    Future<News> getFirst(CriteriaContract criteria) async
    {
        criteria.take(1);

        ModelCollection<News> newses = await get(criteria);

        if(newses.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return newses.first;
        }
    }

    Future<void> persists(News news) async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        news.id = await _newsProvider.persists(news.toMap());
    }

    Future<void> persistsAll(List<News> models) async
    {
        for(News model in models) {
            await persists(model);
        }
    }

    Future<bool> delete(News model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        await _newsProvider.truncate();

        return true;
    }

    Future<bool> update(News model) async
    {
        return false;
    }

    Future<bool> addToFavorite(int id) async
    {
        return await setFavoriteById(id, true);
    }

    Future<bool> removeFromFavorite(int id) async
    {
        return await setFavoriteById(id, false);
    }

    Future<bool> setFavoriteById(int id, bool value) async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        Map<String, dynamic> rows = {
            "is_favorited": value ? 1 : 0,
        };

        return await _newsProvider.update(
            rows: rows,
            where: "id = ?",
            whereArgs: ["$id"]
        );
    }

    Future<bool> updateCounters(News news) async
    {
        try {
            Map<String, dynamic> rows = {
                "favorites_count": news.favoritesCount,
                "views_count": news.viewsCount,
                "comments_count": news.commentsCount,
                "is_favorited": news.isFavorited ? 1 : 0,
                "is_viewed": news.isViewed ? 1 : 0
            };

            _newsProvider.update(
                rows: rows,
                where: "id = ?",
                whereArgs: ["${news.id}"]
            );

            return true;
        } catch (_) {
            return false;
        }
    }
}