import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/page.dart';
import '../api_criteria.dart';

class PageApiRepository extends RepositoryContract<Page, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Page>> get(ApiCriteria criteria) async
    {
        throw Exception('This method not allowed');
    }

    Future<Page> getFirst(ApiCriteria criteria, {String deviceToken}) async
    {
        throw Exception('This method not allowed');
    }

    Future<Page> getByCode(String code) async
    {
        ApiResponse apiResponse = await _apiService
            .pages
            .get(code);

        if(apiResponse.isNotFound) {
            throw RepositoryNotFoundException();
        }

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawPageWithMeta = apiResponse.json();

        if(!rawPageWithMeta.containsKey("data")) {
            throw RepositoryNotFoundException();
        }

        Map<String, dynamic> rawPage = rawPageWithMeta["data"] as Map<String, dynamic>;

        return Page.fromMap(rawPage);
    }

    Future<bool> add(Page news) async
    {
        return false;
    }

    Future<bool> delete(Page model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Page model) async
    {
        return false;
    }
}