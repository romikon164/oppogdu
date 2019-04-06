import "package:oppo_gdu/src/data/models/model.dart";
import "package:oppo_gdu/src/data/models/html_content_element.dart";

class News extends Model
{
    int id;

    String name;

    String image;

    String thumb;

    HtmlContentElementCollection content;

    DateTime createdAt;

    News({this.id, this.name, this.image, this.thumb, this.content, this.createdAt});

    factory News.fromJson(Map<String, dynamic> json)
    {
        return News(
            id: json["id"] as int,
            name: json["name"] as String,
            image: json["image"] as String,
            thumb: json["thumb"] as String,
            content: HtmlContentElementCollection.fromJson(json["content"] as List<dynamic>),
            createdAt: DateTime.fromMillisecondsSinceEpoch(((json["created_at"] as int) ?? 0) * 1000)
        );
    }

    Map<String, dynamic> toJson()
    {
        Map<String, dynamic> json = Map<String, dynamic>();

        json["id"] = id;
        json["name"] = name;
        json["image"] = image;
        json["thumb"] = thumb;
        json["content"] = thumb;
        json["created_at"] = createdAt.millisecondsSinceEpoch;

        return json;
    }
}

class NewsCollection extends ModelCollection<News>
{
    NewsCollection(List<News> items): super(items);

    factory NewsCollection.fromJson(List<dynamic> json)
    {
        if(json == null) {
            return NewsCollection([]);
        }

        return NewsCollection(
          json.map((item) => News.fromJson(item as Map<String, dynamic>)).toList()
        );
    }

    List<dynamic> toJson()
    {
        return map((item) => item.toJson()).toList();
    }
}