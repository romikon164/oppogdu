import '../repository_contract.dart';
import '../../models/model_collection.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import '../exceptions/not_found.dart';
import '../../models/documents/document.dart';
import '../api_criteria.dart';


class DocumentApiRepository extends RepositoryContract<Document, ApiCriteria>
{
    ApiService _apiService = ApiService.instance;

    Future<ModelCollection<Document>> get([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.documents.getList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawDocumentsWithMeta = apiResponse.json();
        List<dynamic> rawDocuments = rawDocumentsWithMeta["data"] as List<dynamic>;

        return ModelCollection(Document.fromList(rawDocuments));
    }

    Future<ModelCollection<Document>> getPrints([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.documents.getPrintList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawDocumentsWithMeta = apiResponse.json();
        List<dynamic> rawDocuments = rawDocumentsWithMeta["data"] as List<dynamic>;

        return ModelCollection(Document.fromList(rawDocuments));
    }

    Future<ModelCollection<Document>> getActs([ApiCriteria criteria]) async
    {
        ApiResponse apiResponse = await _apiService.documents.getActList();

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawDocumentsWithMeta = apiResponse.json();
        List<dynamic> rawDocuments = rawDocumentsWithMeta["data"] as List<dynamic>;

        return ModelCollection(Document.fromList(rawDocuments));
    }

    Future<Document> getFirst(ApiCriteria criteria) async
    {
        criteria.take(1);

        ModelCollection<Document> documents = await get(criteria);

        if(documents.isEmpty) {
            throw RepositoryNotFoundException();
        } else {
            return documents.first;
        }
    }

    Future<Document> getById(int id) async
    {
        ApiResponse apiResponse = await _apiService
            .documents
            .getDetail(id);

        if(apiResponse.isNotFound) {
            throw RepositoryNotFoundException();
        }

        if(!apiResponse.isOk) {
            throw RequestException(apiResponse.status, apiResponse.errors().message);
        }

        Map<String, dynamic> rawDocumentsWithMeta = apiResponse.json();

        if(!rawDocumentsWithMeta.containsKey("data")) {
            throw RepositoryNotFoundException();
        }

        Map<String, dynamic> rawDocuments = rawDocumentsWithMeta["data"] as Map<String, dynamic>;

        return Document.fromMap(rawDocuments);
    }

    Future<bool> add(Document model) async
    {
        return false;
    }

    Future<bool> delete(Document model) async
    {
        return false;
    }

    Future<bool> deleteAll() async
    {
        return false;
    }

    Future<bool> update(Document model) async
    {
        return false;
    }
}