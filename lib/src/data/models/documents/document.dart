import '../model.dart';
import 'package:oppo_gdu/src/support/datetime/formatter.dart';

class DocumentTypes
{
    static const PRINTS = 'prints';

    static const ACTS = 'acts';
}

class Document extends Model
{
    int id;

    String type;

    String name;

    String image;

    String thumb;

    String url;

    String description;

    DateTime createdAt;

    Document({
        this.id,
        this.type,
        this.name,
        this.image,
        this.thumb,
        this.url,
        this.description,
        this.createdAt
    });

    factory Document.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Document(
            id: map["id"] as int,
            type: map["type"] as String,
            name: map["name"] as String,
            image: map["image"] as String,
            thumb: map["thumb"] as String,
            url: map["url"] as String,
            description: map["description"] as String,
            createdAt: DateTimeFormatter.dateTimeFromSeconds(map["created_at"]),
        );
    }

    Map<String, dynamic> toMap()
    {
        return {
            "id": id,
            "type": type,
            "name": name,
            "image": image,
            "thumb": thumb,
            "url": url,
            "description": description,
            "created_at": createdAt.millisecondsSinceEpoch ~/ 1000,
        };
    }

    static List<Document> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Document>(
                (document) => Document.fromMap(
                    document as Map<String, dynamic>
            )
        ).toList();
    }
}