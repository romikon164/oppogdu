import 'repository_contract.dart';
import '../models/model.dart';
import '../database/service.dart';
import 'database_criteria.dart';

abstract class DatabaseRepositoryContract<T extends Model> implements RepositoryContract<T, DatabaseCriteria>
{
    DatabaseProviderContract get provider;
}