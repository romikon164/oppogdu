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

    String introText;

    String content;

    DateTime createdAt;

    int viewsCount;

    int favoritesCount;

    int commentsCount;

    bool isViewed;

    bool isFavorited;

    String sharedUrl;

    News({
        this.id,
        this.name,
        this.image,
        this.thumb,
        this.introText,
        this.content,
        this.createdAt,
        this.viewsCount,
        this.commentsCount,
        this.favoritesCount,
        this.isFavorited,
        this.isViewed,
        this.sharedUrl
    });

    factory News.fromMap(Map<String, dynamic> map)
    {
        return News(
            id: map["id"] as int,
            name: map["name"] as String,
            image: map["image"] as String,
            thumb: map["thumb"] as String,
            introText: map["intro_text"] as String,
            content: map["content"] as String,
            createdAt: DateTimeFormatter.dateTimeFromSeconds(map["created_at"]),
            viewsCount: map["views_count"] as int,
            favoritesCount: map["favorites_count"] as int,
            commentsCount: map["comments_count"] as int,
            isViewed: map["is_viewed"] as bool,
            isFavorited: map["is_favorited"] as bool,
            sharedUrl: map["shared_url"] as String,
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["name"] = name;
        map["image"] = image;
        map["thumb"] = thumb;
        map["intro_text"] = introText;
        map["content"] = content;
        map["created_at"] = createdAt.millisecondsSinceEpoch ~/ 1000;
        map["views_count"] = viewsCount;
        map["favorites_count"] = favoritesCount;
        map["comments_count"] = commentsCount;
        map["is_viewed"] = isViewed;
        map["is_favorited"] = isFavorited;
        map["shared_url"] = sharedUrl;

        return map;
    }

    static List<News> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<News>((news) => News.fromMap(news as Map<String, dynamic>)).toList();
    }
}