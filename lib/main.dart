import 'package:flutter/material.dart';
import 'package:oppo_gdu/src/support/routing/router.dart';
import 'package:oppo_gdu/src/http/api/api.dart';

void main() => runApp(Application());

class Application extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        Api.buildInstance(
            clientId: 2,
            clientSecret: "o9SRuHh8SDzVPB7DoR8E64WIBG44nfkGLd2vySRe"
        );

        Router router = Router();

        return MaterialApp(
            home: router.createNewsListPresenter().view,
            navigatorKey: router.navigatorKey,
            theme: ThemeData(
                appBarTheme: AppBarTheme(
                    brightness: Brightness.light,
                    color: Color.fromARGB(255, 0, 114, 197),
                    iconTheme: IconThemeData(
                        color: Colors.white,
                    ),
                    actionsIconTheme: IconThemeData(
                        color: Colors.white,
                    ),
                ),
                iconTheme: IconThemeData(
                    color: Color.fromARGB(255, 90, 90, 90),
                    size: 24,
                ),
                accentIconTheme: IconThemeData(
                    color: Color.fromARGB(255, 0, 114, 197),
                    size: 24,
                ),
                textTheme: TextTheme(
                    subhead: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                    overline: TextStyle(
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.1,
                        color: Colors.black54,
                        fontSize: 12,
                    ),
                    display1: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 90, 90, 90)
                    )
                ),
                accentTextTheme: TextTheme(
                    display1: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 0, 114, 197)
                    )
                ),
                backgroundColor: Colors.white
            ),
        );
    }
}
