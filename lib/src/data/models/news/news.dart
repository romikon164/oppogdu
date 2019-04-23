import "package:oppo_gdu/src/data/models/model.dart";
import "package:oppo_gdu/src/data/models/html_content_element.dart";
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import '../model_collection.dart';

class News extends Model
{
    int id;

    String name;

    String image;

    String thumb;

    ModelCollection<HtmlContentElement> content;

    DateTime createdAt;

    News({this.id, this.name, this.image, this.thumb, this.content, this.createdAt});

    String get introText {
        if(content.isNotEmpty) {
            for(HtmlContentElement contentElement in content) {
                if(contentElement.type == HtmlContentElement.TYPE_TEXT) {
                    return contentElement.content;
                }
            }
        }

        return null;
    }

    factory News.fromMap(Map<String, dynamic> map)
    {
        return News(
            id: map["id"] as int,
            name: map["name"] as String,
            image: map["image"] as String,
            thumb: map["thumb"] as String,
            content: ModelCollection<HtmlContentElement>(
                HtmlContentElement.fromList(map["content"])
            ),
            createdAt: DateTimeFormatter.dateTimeFromSeconds(map["created_at"])
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["name"] = name;
        map["image"] = image;
        map["thumb"] = thumb;
        map["content"] = content.map<Map<String, dynamic>>((item) => item.toMap()).toList();
        map["created_at"] = createdAt.millisecondsSinceEpoch ~/ 1000;

        return map;
    }

    static List<News> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<News>((news) => News.fromMap(news as Map<String, dynamic>)).toList();
    }
}