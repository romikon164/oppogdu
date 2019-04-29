import "package:oppo_gdu/src/data/models/model.dart";
import 'package:oppo_gdu/src/support/datetime/formatter.dart';

class Photo extends Model
{
    int id;

    int albumId;

    String name;

    String description;

    String image;

    String thumb;

    int favoritesCount;

    int viewsCount;

    bool isFavorited;

    DateTime createdAt;

    Photo({
        this.id,
        this.albumId,
        this.name,
        this.description,
        this.image,
        this.thumb,
        this.favoritesCount,
        this.viewsCount,
        this.isFavorited,
        this.createdAt
    });

    factory Photo.fromMap(Map<String, dynamic> map)
    {
        return Photo(
            id: map["id"] as int,
            albumId: map["album_id"],
            name: map["name"] as String,
            description: map["description"] as String,
            image: map["image"] as String,
            thumb: map["thumb"] as String,
            favoritesCount: map["favorites_count"] as int,
            viewsCount: map["views_count"] as int,
            isFavorited: map["is_favorited"] as bool,
            createdAt: DateTimeFormatter.dateTimeFromSeconds(map["created_at"]),
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["album_id"] = albumId;
        map["name"] = name;
        map["description"] = description;
        map["image"] = image;
        map["thumb"] = thumb;
        map["favorites_count"] = favoritesCount;
        map["views_count"] = viewsCount;
        map["is_favorited"] = isFavorited;
        map["created_at"] = createdAt.millisecondsSinceEpoch ~/ 1000;

        return map;
    }

    static List<Photo> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Photo>((photo) => Photo.fromMap(photo as Map<String, dynamic>)).toList();
    }
}