import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/users/organication.dart';
import '../api_criteria.dart';


class OrganizationApiRepository extends RepositoryContract<Organization, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Organization>> get([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.organizations.getList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawOrganizationsWithMeta = apiResponse.json();
        List<dynamic> rawWorkers = rawOrganizationsWithMeta["data"] as List<dynamic>;

        return ModelCollection(Organization.fromList(rawWorkers));
    }

    Future<Organization> getFirst(ApiCriteria criteria) async
    {
        criteria.take(1);

        ModelCollection<Organization> organizations = await get(criteria);

        if(organizations.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return organizations.first;
        }
    }

    Future<Organization> getById(int id) async
    {
        ApiResponse apiResponse = await _apiService
          .organizations
          .getDetail(id);

        if(apiResponse.isNotFound) {
            throw RepositoryNotFoundException();
        }

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawOrganizationsWithMeta = apiResponse.json();

        if(!rawOrganizationsWithMeta.containsKey("data")) {
            throw RepositoryNotFoundException();
        }

        Map<String, dynamic> rawOrganizations = rawOrganizationsWithMeta["data"] as Map<String, dynamic>;

        return Organization.fromMap(rawOrganizations);
    }

    Future<bool> add(Organization model) async
    {
        return false;
    }

    Future<bool> delete(Organization model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Organization model) async
    {
        return false;
    }
}