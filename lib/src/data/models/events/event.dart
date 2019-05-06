import "package:oppo_gdu/src/data/models/model.dart";
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'category.dart';

class Event extends Model
{
    int id;

    String name;

    String description;

    EventCategory category;

    DateTime startsAt;

    DateTime createdAt;

    Event({
        this.id,
        this.name,
        this.description,
        this.category,
        this.startsAt,
        this.createdAt
    });

    factory Event.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Event(
            id: map["id"] as int,
            name: map["name"] as String,
            description: map["description"] as String,
            category: EventCategory.fromMap(map["category"]),
            startsAt: DateTimeFormatter.dateTimeFromSeconds(map["starts_at"]),
            createdAt: DateTimeFormatter.dateTimeFromSeconds(map["created_at"]),
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["name"] = name;
        map["description"] = description;
        map["category"] = category.toMap();
        map["starts_at"] = createdAt.millisecondsSinceEpoch ~/ 1000;
        map["created_at"] = createdAt.millisecondsSinceEpoch ~/ 1000;

        return map;
    }

    static List<Event> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Event>(
            (event) => Event.fromMap(event as Map<String, dynamic>)
        ).toList();
    }
}