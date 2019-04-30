import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/contacts.dart';
import '../api_criteria.dart';


class ContactsApiRepository extends RepositoryContract<Contacts, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Contacts>> get(ApiCriteria criteria, {String deviceToken}) async
    {
        throw Exception("Not available method");
    }

    Future<Contacts> getFirst(ApiCriteria criteria, {String deviceToken}) async
    {
        throw Exception("Not available method");
    }

    Future<Contacts> getCompanyContacts() async
    {
        ApiResponse apiResponse = await _apiService.contacts.getCompanyContacts();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawContactsWithMeta = apiResponse.json();

        Map<String, dynamic> rawContacts = rawContactsWithMeta["data"] as Map<String, dynamic>;

        return Contacts.fromMap(rawContacts);
    }

    Future<bool> add(Contacts contacts) async
    {
        return false;
    }

    Future<bool> delete(Contacts contacts) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Contacts contacts) async
    {
        return false;
    }
}