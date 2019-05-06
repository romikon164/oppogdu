import "package:oppo_gdu/src/data/models/model.dart";
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import 'photo.dart';

class PhotoAlbum extends Model
{
    int id;

    String name;

    String description;

    String image;

    String thumb;

    List<Photo> photos;

    DateTime createdAt;

    PhotoAlbum({
        this.id,
        this.name,
        this.description,
        this.image,
        this.thumb,
        this.photos,
        this.createdAt
    });

    factory PhotoAlbum.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return PhotoAlbum(
            id: map["id"] as int,
            name: map["name"] as String,
            description: map["description"] as String,
            image: map["image"] as String,
            thumb: map["thumb"] as String,
            photos: Photo.fromList(map["photos"]),
            createdAt: DateTimeFormatter.dateTimeFromSeconds(map["created_at"]),
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["name"] = name;
        map["description"] = description;
        map["image"] = image;
        map["thumb"] = thumb;
        map["created_at"] = createdAt.millisecondsSinceEpoch ~/ 1000;

        return map;
    }

    static List<PhotoAlbum> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<PhotoAlbum>((photoAlbum) => PhotoAlbum.fromMap(photoAlbum as Map<String, dynamic>)).toList();
    }
}