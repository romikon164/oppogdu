import '../models/model.dart';
import '../models/model_collection.dart';

abstract class RepositoryContract<T extends Model>
{
    int get pageSize;

    Future<T> retrieve(int id);

    Future<ModelCollection<T>> retrieveAll({int page = 0, int withStartIndex});

    Future<void> persists(T model);

    Future<void> persistsAll(List<T> models);

    Future<void> delete(T model);

    Future<void> deleteAll(List<T> models);

    Future<void> update(T model);

    Future<void> updateAll(List<T> models);

    Future<void> truncate();
}