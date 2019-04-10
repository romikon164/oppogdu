import '../models/model.dart';
import '../models/model_collection.dart';

abstract class RepositoryContract<T extends Model>
{
    Future<T> retrieve(int id);

    Future<ModelCollection<T>> retrieveAll({int offset = 0, int limit});

    Future<void> persists(T model);

    Future<void> persistsAll(List<T> models);

    Future<void> delete(T model);

    Future<void> deleteAll(List<T> models);

    Future<void> update(T model);

    Future<void> updateAll(List<T> models);

    Future<void> truncate();
}