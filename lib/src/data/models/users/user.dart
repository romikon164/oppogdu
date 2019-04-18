import '../model.dart';

class User extends Model
{
    int id;

    String email;

    String phone;

    String firstname;

    String lastname;

    String secondname;

    String photo;
    
    String get fullname => "$lastname $firstname $secondname".trim();
    
    set fullname(String value) {
        firstname = null;
        lastname = null;
        secondname = null;

        if(value != null && value.isNotEmpty) {
            List<String> elements = value.split(" ")
                .where((item) => item.isNotEmpty)
                .toList();

            if(elements.length == 1) {
                firstname = elements[0];
            } else if(elements.length == 2) {
                firstname = elements[0];
                lastname = elements[1];
            } else if(elements.length != 0) {
                firstname = elements[1];
                lastname = elements[0];
                secondname = elements[2];
            }
        }
    }

    User({this.id, this.email, this.phone, this.firstname, this.lastname, this.secondname, this.photo});

    factory User.fromMap(Map<String, dynamic> map)
    {
        return User(
            id: map["id"],
            email: map["email"],
            phone: map["phone"],
            firstname: map["first_name"],
            lastname: map["last_name"],
            secondname: map["second_name"],
            photo: map["photo"],
        );
    }
    
    Map<String, dynamic> toMap()
    {
        return {
            "id": id,
            "email": email,
            "phone": phone,
            "first_name": firstname,
            "last_name": lastname,
            "second_name": secondname,
            "photo": photo,
        };
    }
}