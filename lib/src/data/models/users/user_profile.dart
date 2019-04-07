import "package:oppo_gdu/src/data/models/model.dart";

class UserProfile extends Model
{
    int id;

    String firstname;

    String lastname;

    String secondname;

    String fullname;

    String photo;

    String email;

    String phone;

    UserProfile({this.id, this.firstname, this.lastname, this.secondname, this.fullname, this.photo, this.email, this.phone});

    factory UserProfile.fromJson(Map<String, dynamic> json)
    {
        return UserProfile(
            id: json["id"] as int,
            firstname: json["firstname"] as String,
            lastname: json["lastname"] as String,
            secondname: json["secondname"] as String,
            fullname: json["fullname"] as String,
            photo: json["photo"] as String,
            email: json["email"] as String,
            phone: json["phone"] as String,
        );
    }

    Map<String, dynamic> toJson()
    {
        Map<String, dynamic> json = Map<String, dynamic>();

        json["id"] = id;
        json["firstname"] = firstname;
        json["lastname"] = lastname;
        json["secondname"] = secondname;
        json["fullname"] = fullname;
        json["photo"] = photo;
        json["email"] = email;
        json["phone"] = phone;

        return json;
    }
}

class UserProfileCollection extends ModelCollection<UserProfile>
{
    UserProfileCollection(List<UserProfile> items): super(items);

    factory UserProfileCollection.fromJson(List<dynamic> json)
    {
        if(json == null) {
            return UserProfileCollection([]);
        }

        return UserProfileCollection(
          json.map((item) => UserProfile.fromJson(item as Map<String, dynamic>)).toList()
        );
    }

    List<dynamic> toJson()
    {
        return map((item) => item.toJson()).toList();
    }
}