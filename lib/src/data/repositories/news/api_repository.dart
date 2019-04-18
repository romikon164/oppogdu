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
        NewsRetrieveApiParameters parameters = NewsRetrieveApiParameters(
            offset: criteria.getOffset(),
            limit: criteria.getLimit(),
            sortBy: criteria.getSortBy(),
            sortDir: criteria.getSortDirection(),
            leftBound: criteria.getFilterValueByName("left_bound") as int,
            rightBound: criteria.getFilterValueByName("right_bound") as int,
        );

        Map<String, dynamic> rawNewsWithMeta = await _apiService.retrieveNewsList(parameters);

        List<dynamic> rawNewses = rawNewsWithMeta["data"] as List<dynamic>;

        return ModelCollection(News.fromList(rawNewses));
    }

    Future<News> getFirst(ApiCriteria criteria) async
    {
        criteria.take(1);

        ModelCollection<News> newses = await get(criteria);

        if(newses.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return newses.first;
        }
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
}