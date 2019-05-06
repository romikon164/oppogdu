import 'model.dart';

class SocialNetwork extends Model
{
    static const FACEBOOK = 'facebook';

    static const TWITTER = 'twitter';

    static const INSTAGRAM = 'instagram';

    static const VKONTAKTE = 'vkontakte';

    int id;

    String name;

    String title;

    String url;

    String icon;

    SocialNetwork({this.id, this.name, this.title, this.url, this.icon});

    factory SocialNetwork.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return SocialNetwork(
            id: map["id"] as int,
            name: map["name"] as String,
            title: map["title"] as String,
            url: map["url"] as String,
            icon: map["icon"] as String,
        );
    }

    Map<String, dynamic> toMap()
    {
        return {
            "id": id,
            "name": name,
            "title": title,
            "url": url,
            "icon": icon,
        };
    }

    static List<SocialNetwork> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<SocialNetwork>(
                (socialNetwork) => SocialNetwork
                    .fromMap(socialNetwork as Map<String, dynamic>)
        ).toList();
    }
}