import "package:oppo_gdu/src/data/models/model.dart";

class Hall extends Model
{
    int id;

    String name;

    Hall({
        this.id,
        this.name,
    });

    factory Hall.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Hall(
            id: map["id"] as int,
            name: map["name"] as String,
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["name"] = name;

        return map;
    }

    static List<Hall> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Hall>((hall) => Hall.fromMap(hall as Map<String, dynamic>)).toList();
    }
}