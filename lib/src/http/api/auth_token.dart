part of 'service.dart';

class AuthToken
{
    static const TYPE_BEARER = "Bearer";

    final String type;

    final String accessToken;

    final String refreshToken;

    final int expiresIn;

    AuthToken({this.type, this.accessToken, this.refreshToken, this.expiresIn});
}