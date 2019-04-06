import "package:quiver/collection.dart";

abstract class Model
{
    Model();

    factory Model.fromJson(Map<String, dynamic> json)
    {
        throw Exception("Model.fromJson the abstract constructor");
    }

    Map<String, dynamic> toJson();
}

abstract class ModelCollection<T extends Model> extends DelegatingList<T>
{
    List<T> _models = [];

    List<T> get delegate => _models;

    ModelCollection(this._models);

    factory ModelCollection.fromJson(List<dynamic> json)
    {
        throw Exception("ModelCollection.fromJson the abstract constructor");
    }

    List<dynamic> toJson();
}