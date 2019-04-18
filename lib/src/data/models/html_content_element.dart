import "model.dart";
import 'model_collection.dart';

class HtmlContentElement extends Model
{
    String type;

    String content;

    String link;

    String title;

    ModelCollection<HtmlContentElement> children;

    HtmlContentElement({this.type, this.content, this.link, this.title, this.children});

    factory HtmlContentElement.fromMap(Map<String, dynamic> map)
    {
        return HtmlContentElement(
            type: map["type"] as String,
            content: map["content"] as String,
            link: map["link"] as String,
            title: map["title"] as String,
            children: HtmlContentElement.fromList(map["children"]),
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["type"] = type;

        if(content != null) {
            map["content"] = content;
        }

        if(link != null) {
            map["link"] = link;
        }

        if(title != null) {
            map["title"] = title;
        }

        if(children != null) {
            map["children"] = children.map((item) => item.toMap());
        }

        return map;
    }

    static List<HtmlContentElement> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<HtmlContentElement>((item) => HtmlContentElement.fromMap(item as Map<String, dynamic>)).toList();
    }
}