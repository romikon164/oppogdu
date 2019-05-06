import "package:oppo_gdu/src/data/models/model.dart";
import 'package:oppo_gdu/src/support/datetime/formatter.dart';
import '../users/user.dart';

class Comment extends Model
{
    int id;

    int newsId;

    User user;

    String text;

    DateTime createdAt;

    Comment({
        this.id,
        this.user,
        this.text,
        this.createdAt
    });

    factory Comment.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Comment(
            id: map["id"] as int,
            user: User.fromMap(map["user"]),
            text: map["content"] as String,
            createdAt: DateTimeFormatter.dateTimeFromSeconds(map["created_at"]),
        );
    }

    Map<String, dynamic> toMap()
    {
        Map<String, dynamic> map = Map<String, dynamic>();

        map["id"] = id;
        map["user"] = user.toMap();
        map["content"] = text;
        map["created_at"] = createdAt.millisecondsSinceEpoch ~/ 1000;

        return map;
    }

    static List<Comment> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Comment>((comment) => Comment.fromMap(comment as Map<String, dynamic>)).toList();
    }
}