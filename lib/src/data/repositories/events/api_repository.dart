import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/events/event.dart';
import '../api_criteria.dart';


class EventApiRepository extends RepositoryContract<Event, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Event>> get([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.events.getList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawEventsWithMeta = apiResponse.json();
        List<dynamic> rawVideos = rawEventsWithMeta["data"] as List<dynamic>;

        return ModelCollection(Event.fromList(rawVideos));
    }

    Future<String> getDescription() async
    {
        ApiResponse apiResponse = await _apiService.events.getDescription();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawEventsWithMeta = apiResponse.json();
        return rawEventsWithMeta["description"] as String;
    }

    Future<Event> getFirst(ApiCriteria criteria) async
    {
        criteria.take(1);

        ModelCollection<Event> events = await get(criteria);

        if(events.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return events.first;
        }
    }

    Future<Event> getById(int id) async
    {
        ApiResponse apiResponse = await _apiService
          .events
          .getDetail(id);

        if(apiResponse.isNotFound) {
            throw RepositoryNotFoundException();
        }

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawEventsWithMeta = apiResponse.json();

        if(!rawEventsWithMeta.containsKey("data")) {
            throw RepositoryNotFoundException();
        }

        Map<String, dynamic> rawEvents = rawEventsWithMeta["data"] as Map<String, dynamic>;

        return Event.fromMap(rawEvents);
    }

    Future<bool> add(Event model) async
    {
        return false;
    }

    Future<bool> delete(Event model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Event model) async
    {
        return false;
    }
}