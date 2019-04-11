import '../database_repository_contract.dart';
import '../../models/news/news.dart';
import '../../database/service.dart';
import '../../database/providers/news.dart';
import '../../models/model_collection.dart';
import '../exceptions/not_found.dart';

class NewsDatabaseRepository extends DatabaseRepositoryContract<News>
{
    NewsDatabaseProvider _newsProvider;

    NewsDatabaseRepository(): super();

    NewsDatabaseProvider get provider => _newsProvider;

    Future<void> _initRepository() async
    {
        _newsProvider = NewsDatabaseProvider(await DatabaseService.instance.database);
    }

    int get pageSize => 15;

    Future<ModelCollection<News>> retrieveAll({int page, int withStartIndex}) async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        List<Map<String, dynamic>> rawNews = await _newsProvider.retrieve(
            where: withStartIndex == null ? null : "id < ?",
            whereArgs: withStartIndex == null ? [] : ["$withStartIndex"],
            orderBy: "created_at desc",
            offset: page * pageSize,
            limit: pageSize
        );

        return ModelCollection<News>(
            rawNews.map<News>((newsItem) => News.fromMap(newsItem))
        );
    }

    Future<News> retrieve(int id) async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        List<Map<String, dynamic>> rawNews = await _newsProvider.retrieve(where: "id = ?", whereArgs: ["$id"]);

        if(rawNews.isEmpty) {
            throw RepositoryNotFoundException();
        }

        return News.fromMap(rawNews.first);
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
        if(_newsProvider == null) {
            await _initRepository();
        }

        _newsProvider.truncate();
    }

    Future<News> retrieveLastSavedModel() async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        List<Map<String, dynamic>> rawNewsList = await _newsProvider.retrieve(orderBy: "id desc", limit: 1);

        if(rawNewsList.length == 0) {
            throw RepositoryNotFoundException();
        }

        return News.fromMap(rawNewsList[0]);
    }

    Future<News> retrieveFirstSavedModel() async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        List<Map<String, dynamic>> rawNewsList = await _newsProvider.retrieve(orderBy: "id asc", limit: 1);

        if(rawNewsList.length == 0) {
            throw RepositoryNotFoundException();
        }

        return News.fromMap(rawNewsList[0]);
    }
}