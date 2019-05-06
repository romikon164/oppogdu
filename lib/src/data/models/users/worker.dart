import '../model.dart';

class Worker extends Model
{
    int id;

    String name;

    String email;

    String phone;

    String photo;

    String thumb;

    String position;

    String description;

    Worker({this.id, this.name, this.email, this.phone, this.photo, this.thumb, this.position, this.description});

    factory Worker.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Worker(
            id: map["id"] as int,
            name: map["name"] as String,
            email: map["email"] as String,
            phone: map["phone"] as String,
            photo: map["photo"] as String,
            thumb: map["thumb"] as String,
            position: map["position"] as String,
            description: map["description"] as String,
        );
    }

    Map<String, dynamic> toMap()
    {
        return {
            "id": id,
            "name": name,
            "email": email,
            "phone": phone,
            "photo": photo,
            "thumb": thumb,
            "position": position,
            "description": description,
        };
    }

    static List<Worker> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Worker>((worker) => Worker.fromMap(worker as Map<String, dynamic>)).toList();
    }
}