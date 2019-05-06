import "package:oppo_gdu/src/data/models/model.dart";

class EventCategory extends Model
{
    int id;

    String name;

    String description;

    EventCategory({
        this.id,
        this.name,
        this.description,
    });

    factory EventCategory.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return EventCategory(
            id: map["id"] as int,
            name: map["name"] as String,
            description: map["description"] as String,
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["name"] = name;
        map["description"] = description;

        return map;
    }

    static List<EventCategory> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<EventCategory>(
            (eventCategory) => EventCategory.fromMap(
              eventCategory as Map<String, dynamic>
          )
        ).toList();
    }
}