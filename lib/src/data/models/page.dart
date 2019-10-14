import "package:oppo_gdu/src/data/models/model.dart";
import 'package:oppo_gdu/src/support/datetime/formatter.dart';

class Page extends Model
{
    int id;

    String name;

    String content;

    DateTime createdAt;

    Page({
        this.id,
        this.name,
        this.content,
        this.createdAt,
    });

    factory Page.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Page(
            id: map["id"] as int,
            name: map["name"] as String,
            content: map["content"] as String,
            createdAt: DateTimeFormatter.dateTimeFromSeconds(map["created_at"]),
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["name"] = name;
        map["content"] = content;
        map["created_at"] = createdAt.millisecondsSinceEpoch ~/ 1000;

        return map;
    }

    static List<Page> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Page>((page) => Page.fromMap(page as Map<String, dynamic>)).toList();
    }
}