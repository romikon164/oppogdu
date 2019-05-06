import "package:oppo_gdu/src/data/models/model.dart";

class VideoCategory extends Model
{
    int id;

    String name;

    String description;

    VideoCategory({
        this.id,
        this.name,
        this.description,
    });

    factory VideoCategory.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return VideoCategory(
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

    static List<VideoCategory> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<VideoCategory>(
            (videoCategory) => VideoCategory.fromMap(
                videoCategory as Map<String, dynamic>
            )
        ).toList();
    }
}