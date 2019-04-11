import 'repository_contract.dart';
import '../models/model.dart';
import '../models/model_collection.dart';
import '../database/service.dart';

abstract class DatabaseRepositoryContract<T extends Model> implements RepositoryContract<T>
{
    DatabaseProviderContract get provider;

    Future<T> retrieveLastSavedModel();

    Future<T> retrieveFirstSavedModel();
}