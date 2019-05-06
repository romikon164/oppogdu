import "package:oppo_gdu/src/data/models/model.dart";
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'category.dart';

class Video extends Model
{
    int id;

    String code;

    String name;

    String description;

    String image;

    String thumb;

    String url;

    VideoCategory category;

    DateTime createdAt;

    Video({
        this.id,
        this.code,
        this.name,
        this.description,
        this.image,
        this.thumb,
        this.url,
        this.category,
        this.createdAt
    });

    factory Video.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Video(
            id: map["id"] as int,
            code: map["code"] as String,
            name: map["name"] as String,
            description: map["description"] as String,
            image: map["image"] as String,
            thumb: map["thumb"] as String,
            url: map["url"] as String,
            category: VideoCategory.fromMap(map["category"]),
            createdAt: DateTimeFormatter.dateTimeFromSeconds(map["created_at"]),
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["code"] = code;
        map["name"] = name;
        map["description"] = description;
        map["image"] = image;
        map["thumb"] = thumb;
        map["url"] = url;
        map["category"] = category.toMap();
        map["created_at"] = createdAt.millisecondsSinceEpoch ~/ 1000;

        return map;
    }

    static List<Video> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Video>(
            (video) => Video.fromMap(video as Map<String, dynamic>)
        ).toList();
    }
}