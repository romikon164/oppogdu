import "package:quiver/collection.dart";
import "model.dart";

class ModelCollection<T extends Model> extends DelegatingList<T>
{
    List<T> _models = [];

    List<T> get delegate => _models;

    final int page;

    final int total;

    ModelCollection(this._models, {this.page, this.total});
}