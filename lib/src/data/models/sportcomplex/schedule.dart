import "package:oppo_gdu/src/data/models/model.dart";
import 'package:oppo_gdu/src/data/models/sportcomplex/hall.dart';
import 'package:oppo_gdu/src/data/models/sportcomplex/trainer.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';

class Schedule extends Model
{
    int id;

    String name;

    String description;

    Hall hall;

    Trainer trainer;

    DateTime startedAt;

    DateTime finishedAt;

    bool infinity;

    Schedule({
        this.id,
        this.name,
        this.description,
        this.hall,
        this.trainer,
        this.startedAt,
        this.finishedAt,
        this.infinity,
    });

    factory Schedule.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Schedule(
            id: map["id"] as int,
            name: map["name"] as String,
            description: map["description"] as String,
            hall:  Hall.fromMap(map["hall"]),
            trainer: Trainer.fromMap(map["trainer"]),
            startedAt: DateTimeFormatter.dateTimeFromSeconds(map["started_at"]),
            finishedAt: DateTimeFormatter.dateTimeFromSeconds(map["finished_at"]),
            infinity: map["infinity"] as bool,
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["name"] = name;
        map["description"] = description;
        map["hall"] = hall.toMap();
        map["trainer"] = trainer.toMap();
        map["started_at"] = startedAt.millisecondsSinceEpoch ~/ 1000;
        map["finished_at"] = finishedAt.millisecondsSinceEpoch ~/ 1000;
        map["infinity"] = infinity;

        return map;
    }

    static List<Schedule> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Schedule>((schedule) => Schedule.fromMap(schedule as Map<String, dynamic>)).toList();
    }
}