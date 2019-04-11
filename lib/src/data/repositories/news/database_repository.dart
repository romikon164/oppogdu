import '../database_repository_contract.dart';
import '../../models/news/news.dart';
import '../../database/service.dart';
import '../../database/providers/news.dart';
import '../../models/model_collection.dart';
import '../exceptions/not_found.dart';
import '../database_criteria.dart';
import '../criteria.dart';

class NewsDatabaseRepository extends DatabaseRepositoryContract<News>
{
    NewsDatabaseProvider _newsProvider;

    NewsDatabaseRepository(): super();

    NewsDatabaseProvider get provider => _newsProvider;

    Future<void> _initRepository() async
    {
        _newsProvider = NewsDatabaseProvider(await DatabaseService.instance.database);
    }

    Future<bool> add(News news) async
    {
        if(_newsProvider == null) {
            await _initRepository();
        }

        try {
            news.id = await _newsProvider.persists(news.toMap());
            return true;
        } catch(e) {
            return false;
        }
    }

    Future<ModelCollection<News>> get(CriteriaContract criteria) async
    {
        DatabaseCriteria databaseCriteria = criteria as DatabaseCriteria;

        if(_newsProvider == null) {
            await _initRepository();
        }

        List<Map<String, dynamic>> rawNewses = await _newsProvider.retrieve(
            where: databaseCriteria.getWhere(),
            orderBy: databaseCriteria.getSort(),
            offset: databaseCriteria.getOffset(),
            limit: databaseCriteria.getLimit()
        );

        return ModelCollection<News>(
            rawNewses.map<News>((news) => News.fromMap(news))
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
}