import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/support/routing/router.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import 'package:oppo_gdu/src/ui/themes/theme.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/data/database/service.dart';
import 'package:oppo_gdu/src/data/database/providers/news.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(Application());

class Application extends StatelessWidget
{
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    Application({Key key}): super(key: key) {
        _firebaseInitialize();
        _databaseInitialize();
        _apiInitialize();
    }

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context)
    {
        Router router = Router();

        return MaterialApp(
            home: NewsListPresenter(router).view as StatefulWidget,
            navigatorKey: router.navigatorKey,
            theme: ThemeBuilder().build(),
        );
    }

    void _firebaseInitialize()
    {
        _firebaseMessaging.configure(
            onMessage: (Map<String, dynamic> message) async {
                print("onMessage: $message");
            },
            onLaunch: (Map<String, dynamic> message) async {
                print("onLaunch: $message");
            },
            onResume: (Map<String, dynamic> message) async {
                print("onResume: $message");
            },
        );

        _firebaseMessaging.requestNotificationPermissions(
            const IosNotificationSettings(
                sound: true,
                badge: true,
                alert: true
            )
        );

        _firebaseMessaging.onIosSettingsRegistered
            .listen((IosNotificationSettings settings) {
                print("Settings registered: $settings");
            });

        _firebaseMessaging.getToken().then((String token) {
            // assert(token != null);

            AuthService.instance.firebaseToken = token;
            ApiService.instance.deviceToken = token;
        });
    }

    void _databaseInitialize()
    {
        try {
            DatabaseService.instance.addDatabaseProvider(
                "news", NewsDatabaseProvider());
            DatabaseService.instance.database;
        } catch (e) {

        }
    }

    void _apiInitialize()
    {
        ApiService.buildInstance(
            baseUrl: "http://api.oppo-gdu.ru",
            clientId: 2,
            clientSecret: "o9SRuHh8SDzVPB7DoR8E64WIBG44nfkGLd2vySRe"
        );

        AuthService.instance.initService();
    }
}
