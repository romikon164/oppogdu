import '../../repository_contract.dart';
import '../../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../../../models/sportcomplex/hall.dart';
import '../../api_criteria.dart';

class HallApiRepository extends RepositoryContract<Hall, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Hall>> get([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.halls.get();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawHallsWithMeta = apiResponse.json();
        List<dynamic> rawHalls = rawHallsWithMeta["data"] as List<dynamic>;

        return ModelCollection(Hall.fromList(rawHalls));
    }

    Future<Hall> getFirst(ApiCriteria criteria, {String deviceToken}) async
    {
        throw Exception('This method not allowed');
    }

    Future<bool> add(Hall news) async
    {
        return false;
    }

    Future<bool> delete(Hall model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Hall model) async
    {
        return false;
    }
}