import 'model.dart';
import 'social_network.dart';

class Contacts extends Model
{
    String name;

    String logo;

    String email;

    String phone;

    String city;

    String address;

    double latitude;

    double longitude;

    List<SocialNetwork> socialNetworks;

    Contacts({
        this.name,
        this.logo,
        this.email,
        this.phone,
        this.city,
        this.address,
        this.latitude,
        this.longitude,
        this.socialNetworks
    });

    factory Contacts.fromMap(Map<String, dynamic> map)
    {
        if(map == null) {
            return null;
        }

        return Contacts(
            name: map["name"] as String,
            logo: map["logo"] as String,
            email: map["email"] as String,
            phone: map["phone"] as String,
            city: map["city"] as String,
            address: map["address"] as String,
            latitude: map["latitude"] as double,
            longitude: map["longitude"] as double,
            socialNetworks: SocialNetwork.fromList(map["social_networks"])
        );
    }

    Map<String, dynamic> toMap()
    {
        return {
            "name": name,
            "logo": logo,
            "email": email,
            "phone": phone,
            "city": city,
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "socialNetworks": socialNetworks.map(
                (socialNetwork) => socialNetwork.toMap()
            ).toList(),
        };
    }
}