import "package:oppo_gdu/src/data/models/model.dart";

class HtmlContentElement extends Model
{
    String type;

    String content;

    String link;

    String title;

    HtmlContentElementCollection children;

    HtmlContentElement({this.type, this.content, this.link, this.title, this.children});

    factory HtmlContentElement.fromJson(Map<String, dynamic> json)
    {
        return HtmlContentElement(
            type: json["type"] as String,
            content: json["content"] as String,
            link: json["link"] as String,
            title: json["title"] as String,
            children: HtmlContentElementCollection.fromJson(json["children"] as List<dynamic>),
        );
    }

    Map<String, dynamic> toJson()
    {
        Map<String, dynamic> json = Map<String, dynamic>();

        json["type"] = type;

        if(content != null) {
            json["content"] = content;
        }

        if(link != null) {
            json["link"] = link;
        }

        if(title != null) {
            json["title"] = title;
        }

        if(children != null) {
            json["children"] = children.toJson();
        }

        return json;
    }
}

class HtmlContentElementCollection extends ModelCollection<HtmlContentElement>
{
    HtmlContentElementCollection(List<HtmlContentElement> items): super(items);

    factory HtmlContentElementCollection.fromJson(List<dynamic> json)
    {
        if(json == null) {
            return HtmlContentElementCollection([]);
        }

        return HtmlContentElementCollection(
            json.map((item) => HtmlContentElement.fromJson(item as Map<String, dynamic>)).toList()
        );
    }

    List<dynamic> toJson()
    {
        return map((item) => item.toJson()).toList();
    }
}