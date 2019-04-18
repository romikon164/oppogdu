import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/support/routing/router.dart';
import 'package:oppo_gdu/src/http/api/service.dart';
import 'package:oppo_gdu/src/ui/themes/theme.dart';
import 'package:oppo_gdu/src/support/auth/service.dart';
import 'package:oppo_gdu/src/presenters/news/news_list_presenter.dart';
import 'package:oppo_gdu/src/data/database/service.dart';
import 'package:oppo_gdu/src/data/database/providers/news.dart';

void main() => runApp(Application());

class Application extends StatelessWidget
{
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context)
    {
        try {
            DatabaseService.instance.addDatabaseProvider(
                "news", NewsDatabaseProvider());
            DatabaseService.instance.database;
        } catch (e) {

        }

        ApiService.buildInstance(
            baseUrl: "http://api.oppo-gdu.ru",
            clientId: 2,
            clientSecret: "o9SRuHh8SDzVPB7DoR8E64WIBG44nfkGLd2vySRe"
        );

        AuthService.instance.initService();

        Router router = Router();

        return MaterialApp(
            home: NewsListPresenter(router).view as StatefulWidget,
            navigatorKey: router.navigatorKey,
            theme: ThemeBuilder().build(),
        );
    }
}
