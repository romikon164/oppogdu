

class HtmlContentElement
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
}

class HtmlContentElementCollection
{
    List<HtmlContentElement> items = [];

    HtmlContentElementCollection(this.items);

    factory HtmlContentElementCollection.fromJson(List<dynamic> json)
    {
        if(json == null) {
            return HtmlContentElementCollection([]);
        }
        return HtmlContentElementCollection(
            json.map<HtmlContentElement>((item) => HtmlContentElement.fromJson(item as Map<String, dynamic>)).toList()
        );
    }

    List<HtmlContentElement> toList() => items;

    HtmlContentElement operator [](int index) => items[index];
}