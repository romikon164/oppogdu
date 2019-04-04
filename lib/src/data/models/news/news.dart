import 'package:oppo_gdu/src/data/models/html_content_element.dart';

class News
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
            createdAt: DateTime.fromMillisecondsSinceEpoch((json["created_at"] as int) * 1000)
        );
    }
}

class NewsCollection
{
    List<News> items = [];

    NewsCollection(this.items);

    factory NewsCollection.fromJson(List<dynamic> json)
    {
        if(json == null) {
            return NewsCollection([]);
        }
        return NewsCollection(
            json.map<News>((item) => News.fromJson(item as Map<String, dynamic>)).toList()
        );
    }

    List<News> toList() => items;

    News operator [](int index) => items[index];
}