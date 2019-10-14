import '../../repository_contract.dart';
import '../../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../../../models/sportcomplex/trainer.dart';
import '../../api_criteria.dart';

class TrainerApiRepository extends RepositoryContract<Trainer, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Trainer>> get([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.trainers.get();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawTrainersWithMeta = apiResponse.json();
        List<dynamic> rawTrainers = rawTrainersWithMeta["data"] as List<dynamic>;

        return ModelCollection(Trainer.fromList(rawTrainers));
    }

    Future<Trainer> getFirst(ApiCriteria criteria, {String deviceToken}) async
    {
        throw Exception('This method not allowed');
    }

    Future<bool> add(Trainer news) async
    {
        return false;
    }

    Future<bool> delete(Trainer model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Trainer model) async
    {
        return false;
    }
}