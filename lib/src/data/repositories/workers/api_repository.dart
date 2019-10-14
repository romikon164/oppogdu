import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/users/worker.dart';
import '../api_criteria.dart';


class WorkerApiRepository extends RepositoryContract<Worker, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Worker>> get([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.workers.getList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawWorkersWithMeta = apiResponse.json();
        List<dynamic> rawWorkers = rawWorkersWithMeta["data"] as List<dynamic>;

        return ModelCollection(Worker.fromList(rawWorkers));
    }

    Future<ModelCollection<Worker>> getLeaderships([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.workers.getLeadershipsList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawWorkersWithMeta = apiResponse.json();
        List<dynamic> rawWorkers = rawWorkersWithMeta["data"] as List<dynamic>;

        return ModelCollection(Worker.fromList(rawWorkers));
    }

    Future<ModelCollection<Worker>> getSportComplexTrainers([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.workers.getSportComplexTrainers();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawWorkersWithMeta = apiResponse.json();
        List<dynamic> rawWorkers = rawWorkersWithMeta["data"] as List<dynamic>;

        return ModelCollection(Worker.fromList(rawWorkers));
    }

    Future<ModelCollection<Worker>> getSportComplexLeaderships([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.workers.getSportComplexLeaderships();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawWorkersWithMeta = apiResponse.json();
        List<dynamic> rawWorkers = rawWorkersWithMeta["data"] as List<dynamic>;

        return ModelCollection(Worker.fromList(rawWorkers));
    }

    Future<ModelCollection<Worker>> getTrainers([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.workers.getTrainersList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawWorkersWithMeta = apiResponse.json();
        List<dynamic> rawWorkers = rawWorkersWithMeta["data"] as List<dynamic>;

        return ModelCollection(Worker.fromList(rawWorkers));
    }

    Future<Worker> getFirst(ApiCriteria criteria) async
    {
        criteria.take(1);

        ModelCollection<Worker> workers = await get(criteria);

        if(workers.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return workers.first;
        }
    }

    Future<Worker> getById(int id) async
    {
        ApiResponse apiResponse = await _apiService.workers.getDetail(id);

        if(apiResponse.isNotFound) {
            throw RepositoryNotFoundException();
        }

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawWorkersWithMeta = apiResponse.json();

        if(!rawWorkersWithMeta.containsKey("data")) {
            throw RepositoryNotFoundException();
        }

        Map<String, dynamic> rawWorkers = rawWorkersWithMeta["data"] as Map<String, dynamic>;

        return Worker.fromMap(rawWorkers);
    }

    Future<bool> add(Worker model) async
    {
        return false;
    }

    Future<bool> delete(Worker model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Worker model) async
    {
        return false;
    }
}