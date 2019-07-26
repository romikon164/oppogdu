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

    Worker chairman;

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
        this.chairman,
        this.workers,
        this.commissioners
    });

    factory Organization.fromMap(Map<String, dynamic> map)
    {
        print(map);
        if(map == null) {
            return null;
        }

        dynamic latitudeRaw = map["latitude"];
        dynamic longitudeRaw = map["longitude"];
        double latitude = 0;
        double longitude = 0;

        if(latitudeRaw is int) {
            latitude = latitudeRaw.toDouble();
        } else if(latitudeRaw is double) {
            latitude = latitudeRaw;
        }

        if(longitudeRaw is int) {
            longitude = longitudeRaw.toDouble();
        } else if(latitudeRaw is double) {
            longitude = longitudeRaw;
        }

        return Organization(
            id: map["id"] as int,
            name: map["name"] as String,
            email: map["email"] as String,
            phone: map["phone"] as String,
            address: map["address"] as String,
            longitude: longitude,
            latitude: latitude,
            image: map["image"] as String,
            thumb: map["thumb"] as String,
            description: map["description"] as String,
            chairman: Worker.fromMap(map["chairman"]),
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
            "chairman": chairman,
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