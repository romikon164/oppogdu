import '../../repository_contract.dart';
import '../../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../../../models/sportcomplex/schedule.dart';
import '../../api_criteria.dart';

class ScheduleApiRepository extends RepositoryContract<Schedule, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Schedule>> get(ApiCriteria criteria) async
    {
        ApiResponse apiResponse = await _apiService.schedules.get(
            criteria.getFilterValueByName('date', DateTime.now()),
            trainer: criteria.getFilterValueByName('trainer'),
            hall: criteria.getFilterValueByName('hall'),
        );

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawSchedulesWithMeta = apiResponse.json();
        List<dynamic> rawSchedules = rawSchedulesWithMeta["data"] as List<dynamic>;

        return ModelCollection(Schedule.fromList(rawSchedules));
    }

    Future<Schedule> getFirst(ApiCriteria criteria, {String deviceToken}) async
    {
        throw Exception('This method not allowed');
    }

    Future<bool> add(Schedule news) async
    {
        return false;
    }

    Future<bool> delete(Schedule model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Schedule model) async
    {
        return false;
    }
}