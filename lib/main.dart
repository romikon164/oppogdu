import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/support/routing/router.dart';
import 'package:oppo_gdu/src/http/api/api.dart';
import 'package:oppo_gdu/src/ui/themes/theme.dart';

void main() => runApp(Application());

class Application extends StatelessWidget
{
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context)
    {

        Api.buildInstance(
            apiBaseUrl: "http://api.oppo-gdu.ru",
            clientId: 2,
            clientSecret: "o9SRuHh8SDzVPB7DoR8E64WIBG44nfkGLd2vySRe"
        );

        Api.getInstance().auth.attemptAuthForSharedPreferences();

        Router router = Router();

        return MaterialApp(
            home: router.createNewsListPresenter().view,
            navigatorKey: router.navigatorKey,
            theme: ThemeBuilder().build(),
        );
    }
}
