import 'package:oppo_gdu/src/data/models/users/user_profile.dart';
import 'package:oppo_gdu/src/http/api/auth.dart';
import 'package:oppo_gdu/src/http/api/response.dart';

class User
{
    UserProfile profile;

    AuthToken token;

    User(this.token, this.profile);
}