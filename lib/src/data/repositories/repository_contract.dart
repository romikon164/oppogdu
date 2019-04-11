import '../models/model.dart';
import '../models/model_collection.dart';
import 'criteria.dart';

abstract class RepositoryContract<T extends Model, K extends CriteriaContract>
{
    Future<ModelCollection<T>> get(K criteria);

    Future<T> getFirst(K criteria);

    Future<bool> add(T model);

    Future<bool> update(T model);

    Future<bool> delete(T model);

    Future<bool> deleteAll();
}