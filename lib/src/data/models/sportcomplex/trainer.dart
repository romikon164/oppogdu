import "package:oppo_gdu/src/data/models/model.dart";

class Trainer extends Model
{
    int id;

    String name;

    Trainer({
        this.id,
        this.name,
    });

    factory Trainer.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Trainer(
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

    static List<Trainer> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Trainer>((trainer) => Trainer.fromMap(trainer as Map<String, dynamic>)).toList();
    }
}