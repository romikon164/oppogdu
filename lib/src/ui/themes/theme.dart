import 'package:flutter/material.dart';

class ThemeBuilder
{
    ThemeData build()
    {
        return ThemeData(
            accentColor: Color(0xFF0072C5),
            accentColorBrightness: Brightness.light,
            accentIconTheme: _buildAccentIconTheme(),
            accentTextTheme: _buildAccentTextTheme(),
            appBarTheme: _buildAppBarTheme(),
            backgroundColor: Color(0xFF000000),
            bottomAppBarColor: Color(0xFFFFFFFF),
            bottomAppBarTheme: _buildBottomAppBarTheme(),
            brightness: Brightness.light,
            buttonColor: Color(0xFFFFFFFF),
            buttonTheme: _buildButtonTheme(),
            canvasColor: Color(0xFFFFFFFF),
            cardColor: Color(0xFFFFFFFF),
            cardTheme: _buildCardTheme(),
            chipTheme: _buildChipTheme(),
            colorScheme: _buildColorScheme(),
            dialogBackgroundColor: Color(0xFFFFFFFF),
            dialogTheme: _buildDialogTheme(),
            dividerColor: Color(0xFFFFFFFF),
            errorColor: Color(0xFFFFFFFF),
            highlightColor: Color(0xFFFFFFFF),
            hintColor: Color(0xFFFFFFFF),
            iconTheme: _buildIconTheme(),
            indicatorColor: Color(0xFF0072C5),
            inputDecorationTheme: _buildInputDecorationTheme(),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            pageTransitionsTheme: _buildPageTransitionsTheme(),
            primaryColor: Color(0xFF0072C5),
            primaryColorBrightness: Brightness.light,
            primaryColorDark: Color(0xFF0072C5),
            primaryIconTheme: _buildPrimaryIconTheme(),
            primaryTextTheme: _buildPrimaryTextTheme(),
            scaffoldBackgroundColor: Color(0xFFEEEEEE),
            secondaryHeaderColor: Color(0xFFFFFFFF),
            selectedRowColor: Color(0xFFFFFFFF),
            splashColor: Color(0xFFBBBBBB),
            splashFactory: _buildSplashFactory(),
            tabBarTheme: _buildTabBarTheme(),
            textSelectionColor: Color(0xFFFFFFFF),
            textSelectionHandleColor: Color(0xFFFFFFFF),
            textTheme: _buildTextTheme(),
            toggleableActiveColor: Color(0xFFFFFFFF),
            typography: _buildTypography(),
            unselectedWidgetColor: Color(0xFFFFFFFF),
        );
    }

    IconThemeData _buildAccentIconTheme()
    {
        return IconThemeData(
            color: Color(0xFF0072C5),
            size: 24,
        );
    }

    TextTheme _buildAccentTextTheme()
    {
        return TextTheme(
            display1: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFF0072C5)
            ),
            button: TextStyle(
                fontSize: 14,
                color: Color(0xFF0072C5),
                fontWeight: FontWeight.normal
            )
        );
    }

    AppBarTheme _buildAppBarTheme()
    {
        return AppBarTheme(
            brightness: Brightness.light,
            color: Color(0xFF0072C5),
            iconTheme: IconThemeData(
                color: Colors.white,
            ),
            actionsIconTheme: IconThemeData(
                color: Colors.white,
            ),
            textTheme: TextTheme(
                title: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                ),
                subtitle: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                ),
            )
        );
    }

    BottomAppBarTheme _buildBottomAppBarTheme()
    {
        return BottomAppBarTheme(
            color: Color(0xFFFFFFFF)
        );
    }

    ButtonThemeData _buildButtonTheme()
    {
        return ButtonThemeData(
            textTheme: ButtonTextTheme.normal,
            buttonColor: Color(0xFFEAEAEA)
        );
    }

    CardTheme _buildCardTheme()
    {
        return CardTheme(
            color: Color(0xFFFFFFFF),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
            shape: BeveledRectangleBorder(),
        );
    }

    ChipThemeData _buildChipTheme()
    {
        return ChipThemeData(
            backgroundColor: Color(0xFFFFFFFF),
            brightness: Brightness.light,
            disabledColor: Color(0xFFFFFFFF),
            labelPadding: EdgeInsets.all(0),
            labelStyle: TextStyle(),
            padding: EdgeInsets.all(0),
            secondaryLabelStyle: TextStyle(),
            secondarySelectedColor: Color(0xFFFFFFFF),
            selectedColor: Color(0xFFFFFFFF),
            shape: BeveledRectangleBorder()
        );
    }

    ColorScheme _buildColorScheme()
    {
        return ColorScheme(
            background: Color(0xFFFFFFFF),
            brightness: Brightness.light,
            error: Color(0xFFFFFFFF),
            onBackground: Color(0xFFFFFFFF),
            onError: Color(0xFFFFFFFF),
            onPrimary: Color(0xFFFFFFFF),
            onSecondary: Color(0xFFFFFFFF),
            onSurface: Color(0xFFFFFFFF),
            primary: Color(0xFFFFFFFF),
            primaryVariant: Color(0xFFFFFFFF),
            secondary: Color(0xFFFFFFFF),
            secondaryVariant: Color(0xFFFFFFFF),
            surface: Color(0xFFFFFFFF),
        );
    }

    DialogTheme _buildDialogTheme()
    {
        return DialogTheme();
    }

    IconThemeData _buildIconTheme()
    {
        return IconThemeData(
            color: Color(0xFF9B9B9B),
            size: 24,
        );
    }

    InputDecorationTheme _buildInputDecorationTheme()
    {
        return InputDecorationTheme(
            labelStyle: TextStyle(
                color: Color(0xFF9B9B9B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
            ),
            prefixStyle: TextStyle(
                color: Color(0xFF0072C5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFF9B9B9B),
                    width: 1.0
                )
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF9B9B9B),
                width: 1.0
              )
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFAF3434),
                width: 1.0
              )
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFAF3434),
                width: 2.0
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF0072C5),
                width: 2.0
              )
            ),
            errorStyle: TextStyle(
                color: Color(0xFFAF3434),
                fontSize: 12,
                fontWeight: FontWeight.normal
            )
        );
    }

    PageTransitionsTheme _buildPageTransitionsTheme()
    {
        return PageTransitionsTheme(builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
        });
    }

    IconThemeData _buildPrimaryIconTheme()
    {
        return IconThemeData(
            color: Color(0xFFEAEAEA),
            size: 24
        );
    }

    TextTheme _buildPrimaryTextTheme()
    {
        return TextTheme();
    }

    InteractiveInkFeatureFactory _buildSplashFactory()
    {
        return InkSplash.splashFactory;
    }

    TabBarTheme _buildTabBarTheme()
    {
        return TabBarTheme();
    }

    TextTheme _buildTextTheme()
    {
        return TextTheme(
            headline: TextStyle(
                color: Color(0xFF000000),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal
            ),
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
                color: Color(0xFFFFFFFF)
            ),
            button: TextStyle(
                color: Color(0xFF9B9B9B),
                fontSize: 14,
                fontWeight: FontWeight.normal
            ),
            caption: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 14,
            ),
        );
    }

    Typography _buildTypography()
    {
        return Typography();
    }
}