import 'package:http/http.dart' as http;
import 'package:oppo_gdu/src/http/api/response.dart' as ApiResponse;
import 'package:oppo_gdu/src/http/api/api.dart';
import 'dart:convert' as convert;
import 'package:oppo_gdu/src/data/models/users/user.dart';
import 'package:oppo_gdu/src/data/models/users/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth
{
    final Api api;

    static const accessTokenPrefferencesKey = "oppo_gdu_auth_access_token";

    static const refreshTokenPrefferencesKey = "oppo_gdu_auth_refresh_token";

    User currentUser;

    Auth(this.api);

    Future<ApiResponse.Response> createAccount(AuthCreateAccountData data) async
    {
        try {
            http.Response response = await http.post(
                api.baseUrl + '/oauth/register',
                headers: {
                    'Accept': 'application/json',
                },
                body: {
                    'client_id': api.clientId,
                    'client_secret': api.clientSecret,
                    'grant_type': 'password',
                    'email': data.email,
                    'password': data.password,
                    'phone': data.phone,
                    'full_name': data.fullname
                }
            );

            return ApiResponse.Response(
                code: response.statusCode,
                body: convert.jsonDecode(response.body)
            );
        } catch (exception) {
            return ApiResponse.ResponseError(exception.toString());
        }
    }

    Future<AuthToken> requestToken(AuthRequestTokenData data) async
    {
        try {
            http.Response response = await http.post(
                api.baseUrl + '/oauth/token',
                headers: {
                    'Accept': 'application/json',
                },
                body: {
                    'client_id': api.clientId.toString(),
                    'client_secret': api.clientSecret,
                    'grant_type': 'password',
                    'username': data.username,
                    'password': data.password,
                }
            );

            return AuthToken.fromJson(
                convert.jsonDecode(response.body)
            );
        } catch (exception) {

        }

        return null;
    }

    Future<bool> attemptAuthForSharedPreferences() async
    {
        try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String accessToken = prefs.getString(
                Auth.accessTokenPrefferencesKey);
            String refreshToken = prefs.getString(
                Auth.refreshTokenPrefferencesKey);

            if(accessToken != null && refreshToken != null) {
                AuthToken token = AuthToken(
                    accessToken: accessToken,
                    refreshToken: refreshToken
                );

                return await authByToken(token);
            }

        } catch (exception) {
            print(exception.toString());
        }

        return false;
    }

    Future<bool> authByToken(AuthToken token) async
    {
        UserProfile profile = await requestUserProfile(token);

        if(profile != null) {
            currentUser = User(token, profile);

            try {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                    Auth.accessTokenPrefferencesKey, token.accessToken);
                await prefs.setString(
                    Auth.refreshTokenPrefferencesKey, token.refreshToken);
            } catch (exception) {
                print(exception.toString());
            }

            return true;
        }

        return false;
    }

    UserProfile getCurrentUserProfile()
    {
        return currentUser?.profile;
    }

    Future<UserProfile> requestUserProfile(AuthToken token) async
    {
        try {
            http.Response response = await http.get(
                api.baseUrl + '/oauth/profile',
                headers: {
                    'Accept': 'application/json',
                    'Authorization': "Bearer ${token.accessToken}"
                }
            );

            if(response.statusCode == ApiResponse.ResponseCode.ok) {
                return UserProfile.fromJson(
                    convert.jsonDecode(response.body)
                );
            }

        } catch (exception) {

        }

        return null;
    }

}

class AuthCreateAccountData
{
    String email;

    String phone;

    String password;

    String fullname;

    AuthCreateAccountData({this.email, this.phone, this.password, this.fullname});
}

class AuthRequestTokenData
{
    String username;

    String password;

    AuthRequestTokenData({this.username, this.password});
}

class AuthToken
{
    AuthTokenType tokenType;

    DateTime expiresIn;

    String accessToken;

    String refreshToken;

    AuthToken({this.tokenType = AuthTokenType.Bearer, this.expiresIn, this.accessToken, this.refreshToken});

    factory AuthToken.fromJson(Map<String, dynamic> json)
    {
        int expiresInSeconds = json["expires_in"] as int;

        return AuthToken(
            expiresIn: DateTime.fromMillisecondsSinceEpoch(expiresInSeconds * 1000),
            accessToken: json["access_token"] as String,
            refreshToken: json["refresh_token"] as String,
        );
    }
}

enum AuthTokenType
{
    Bearer
}