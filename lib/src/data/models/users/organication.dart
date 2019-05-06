import '../model.dart';
import 'worker.dart';

class Organization extends Model
{
    int id;

    String name;

    String email;

    String phone;

    String address;

    double longitude;

    double latitude;

    String image;

    String thumb;

    String description;

    List<Worker> workers;

    List<Worker> commissioners;

    Organization({
        this.id,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.longitude,
        this.latitude,
        this.image,
        this.thumb,
        this.description,
        this.workers,
        this.commissioners
    });

    factory Organization.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Organization(
            id: map["id"] as int,
            name: map["name"] as String,
            email: map["email"] as String,
            phone: map["phone"] as String,
            address: map["address"] as String,
            longitude: map["longitude"] as double,
            latitude: map["latitude"] as double,
            image: map["image"] as String,
            thumb: map["thumb"] as String,
            description: map["description"] as String,
            workers: Worker.fromList(map["workers"]),
            commissioners: Worker.fromList(map["commissioners"]),
        );
    }

    Map<String, dynamic> toMap()
    {
        return {
            "id": id,
            "name": name,
            "email": email,
            "phone": phone,
            "address": address,
            "longitude": longitude,
            "latitude": latitude,
            "image": image,
            "thumb": thumb,
            "description": description,
            "workers": workers.map<Map<String,dynamic>>((worker) => worker.toMap()).toList(),
            "commissioners": commissioners.map<Map<String,dynamic>>(
                (commissioner) => commissioner.toMap()
            ).toList(),
        };
    }

    static List<Organization> fromList(List<dynamic> list) {
        if(list == null) {
            return [];
        }

        return list.map<Organization>(
            (organization) => Organization.fromMap(
                organization as Map<String, dynamic>
            )
        ).toList();
    }
}