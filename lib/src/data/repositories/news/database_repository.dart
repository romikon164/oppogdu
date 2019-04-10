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

    Future<ModelCollection<News>> retrieveAll({int offset, int limit}) async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        List<Map<String, dynamic>> rawNews = await _newsProvider.retrieve(
            orderBy: "created_at desc",
            offset: offset,
            limit: limit
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
}