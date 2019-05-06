import 'package:shared_preferences/shared_preferences.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import 'dart:convert' as convert;
import 'package:oppo_gdu/src/data/models/users/user.dart';

class AuthService
{
    static const SHARED_PREFERENCES_AUTH_TOKEN_KEY = "auth_token_json";

    static const SHARED_PREFERENCES_AUTH_USER_KEY = "auth_user_json";

    static AuthService _instance;

    static AuthService get instance {
        if(_instance == null) {
            _instance = AuthService._();
        }

        return _instance;
    }
    
    AuthService._();

    User user;

    bool _initialized = false;

    bool get initialized => _initialized;

    String firebaseToken;
    
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

            _initialized = true;

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
        } catch (_) {

        }
    }

    Future<void> attemptUpdateUserData() async
    {
        try {
            Map<String, dynamic> userData = await ApiService.instance.retrieveUserProfile();

            if(userData.containsKey("data")) {
                userData = userData["data"];
            } else {
                return ;
            }

            user = User.fromMap(userData);

            SharedPreferences preferences = await SharedPreferences.getInstance();

            String userJson = convert.jsonEncode(userData);

            preferences.setString(AuthService.SHARED_PREFERENCES_AUTH_USER_KEY, userJson);
        } catch(e) {
            print(e);
        }

        _initialized = true;
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

            ApiService.instance.authToken = authToken;

            String authTokenJson = convert.jsonEncode(authTokenData);

            preferences.setString(AuthService.SHARED_PREFERENCES_AUTH_TOKEN_KEY, authTokenJson);
        } catch(_) {

        }
    }

    bool isAuthenticated()
    {
        return user != null;
    }

    Future<void> authenticate(String phone, String password) async
    {
        _initialized = false;

        AuthToken authToken = await ApiService.instance.requestToken(
            phone,
            password
        );

        ApiService.instance.authToken = authToken;

        await updateAuthToken(authToken);
        await attemptUpdateUserData();
    }

    Future<void> logout() async
    {
        user = null;
        ApiService.instance.authToken = null;

        SharedPreferences preferences = await SharedPreferences.getInstance();

        preferences.remove(AuthService.SHARED_PREFERENCES_AUTH_TOKEN_KEY);
        preferences.remove(AuthService.SHARED_PREFERENCES_AUTH_USER_KEY);
    }
}