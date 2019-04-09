///

abstract class Model
{
    Model();

    factory Model.fromMap(Map<String, dynamic> map) {
        throw Exception("Model.fromMap is not defined");
    }

    Map<String, dynamic> toMap();
}