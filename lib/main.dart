import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:oppo_gdu/src/consts.dart' as AppConsts;
import 'package:oppo_gdu/src/support/routing/router.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import 'package:oppo_gdu/src/ui/themes/theme.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/data/database/service.dart';
import 'package:oppo_gdu/src/data/database/providers/news.dart';
import 'package:oppo_gdu/src/data/database/providers/photo.dart';
import 'package:oppo_gdu/src/data/database/providers/photo_album.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() => initializeDateFormatting().then((_) => runApp(Application()));

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



        _firebaseMessaging.subscribeToTopic('news');
        _firebaseMessaging.subscribeToTopic('photo-albums');
        _firebaseMessaging.subscribeToTopic('videos');
        _firebaseMessaging.subscribeToTopic('sport-complex');
        _firebaseMessaging.subscribeToTopic('prints');
        _firebaseMessaging.subscribeToTopic('aggrement');

        _firebaseMessaging.getToken().then((String token) {
            // assert(token != null);

            AuthService.instance.firebaseToken = token;
            ApiService.instance.deviceToken = token;
        });
    }

    void _databaseInitialize()
    {
        try {
            DatabaseService.instance.addDatabaseProvider("news", NewsDatabaseProvider());
            DatabaseService.instance.addDatabaseProvider("photo-albums", PhotoAlbumDatabaseProvider());
            DatabaseService.instance.addDatabaseProvider("photos", PhotoDatabaseProvider());

            DatabaseService.instance.database;
        } catch (_) {

        }
    }

    void _apiInitialize()
    {
        ApiService.buildInstance(
            baseUrl: AppConsts.OPPO_API_URL,
            clientId: AppConsts.OPPO_CLIENT_ID,
            clientSecret: AppConsts.OPPO_CLIENT_SECRET
        );

        AuthService.instance.initService();
    }
}
