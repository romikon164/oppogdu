import 'package:shared_preferences/shared_preferences.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import 'dart:convert' as convert;
import 'package:oppo_gdu/src/data/models/users/user.dart';

class AuthService
{
    static const SHARED_PREFERENCES_AUTH_TOKEN_KEY = "auth_token_json";

    static const SHARED_PREFERENCES_AUTH_USER_KEY = "auth_user_json";

    User user;

    static AuthService get instance => AuthService._();
    
    AuthService._();
    
    Future<void> initService() async
    {
        try {
            SharedPreferences preferences = await SharedPreferences.getInstance();

            String userJson = preferences.getString(
                AuthService.SHARED_PREFERENCES_AUTH_USER_KEY
            );

            if(userJson != null) {
                Map<String, dynamic> userData = convert.jsonDecode(userJson);
                user = User.fromMap(userData);
            }

            String authTokenJson = preferences.getString(
                AuthService.SHARED_PREFERENCES_AUTH_TOKEN_KEY
            );

            if(authTokenJson != null) {
                Map<String, dynamic> authTokenData = convert.jsonDecode(authTokenJson);

                ApiService.instance.authToken = AuthToken(
                    type: authTokenData["token_type"],
                    accessToken: authTokenData["access_token"],
                    refreshToken: authTokenData["refresh_token"],
                    expiresIn: authTokenData["expires_in"],
                );

                attemptUpdateUserData();
            }
        } catch (e) {
            print(e.toString());
        }
    }

    Future<void> attemptUpdateUserData() async
    {
        try {
            Map<String, dynamic> userData = await ApiService.instance.retrieveUserProfile();
            user = User.fromMap(userData);

            SharedPreferences preferences = await SharedPreferences.getInstance();

            String userJson = convert.jsonEncode(userData);
            preferences.setString(AuthService.SHARED_PREFERENCES_AUTH_USER_KEY, userJson);
        } catch(e) {
            print(e.toString());
        }
    }

    Future<void> updateAuthToken(AuthToken authToken) async
    {
        try {
            SharedPreferences preferences = await SharedPreferences.getInstance();

            Map<String, dynamic> authTokenData = {
                "token_type": authToken.type,
                "access_token": authToken.accessToken,
                "refresh_token": authToken.refreshToken,
                "expires_in": authToken.expiresIn
            };

            String authTokenJson = convert.jsonEncode(authTokenData);

            preferences.setString(AuthService.SHARED_PREFERENCES_AUTH_TOKEN_KEY, authTokenJson);
        } catch(e) {
            print(e.toString());
        }
    }

    bool isAuthenticated()
    {
        return user != null;
    }

    Future<void> authenticate(String phone, String password) async
    {
        AuthToken authToken = await ApiService.instance.requestToken(
            phone,
            password
        );

        ApiService.instance.authToken = authToken;

        await updateAuthToken(authToken);
        await attemptUpdateUserData();
    }
}