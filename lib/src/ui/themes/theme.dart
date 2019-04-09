import 'package:flutter/material.dart';

class ThemeBuilder
{
    ThemeData build()
    {
        return ThemeData(
            accentColor: Color(0xFFFFFFFF),
            accentColorBrightness: Brightness.dark,
            accentIconTheme: _buildAccentIconTheme(),
            accentTextTheme: _buildAccentTextTheme(),
            appBarTheme: _buildAppBarTheme(),
            backgroundColor: Color(0xFFFFFFFF),
            bottomAppBarColor: Color(0xFFFFFFFF),
            bottomAppBarTheme: _buildBottomAppBarTheme(),
            brightness: Brightness.dark,
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
            indicatorColor: Color(0xFFFFFFFF),
            inputDecorationTheme: _buildInputDecorationTheme(),
            materialTapTargetSize: MaterialTapTargetSize.padded,
            pageTransitionsTheme: _buildPageTransitionsTheme(),
            primaryColor: Color(0xFFFFFFFF),
            primaryColorBrightness: Brightness.dark,
            primaryColorDark: Color(0xFFFFFFFF),
            primaryIconTheme: _buildPrimaryIconTheme(),
            primaryTextTheme: _buildPrimaryTextTheme(),
            scaffoldBackgroundColor: Color(0xFFFFFFFF),
            secondaryHeaderColor: Color(0xFFFFFFFF),
            selectedRowColor: Color(0xFFFFFFFF),
            // sliderTheme: _buildSliderTheme(),
            splashColor: Color(0xFFFFFFFF),
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
            color: Color.fromARGB(255, 0, 114, 197),
            size: 24,
        );
    }

    TextTheme _buildAccentTextTheme()
    {
        return TextTheme(
            display1: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 0, 114, 197)
            )
        );
    }

    AppBarTheme _buildAppBarTheme()
    {
        return AppBarTheme(
            brightness: Brightness.light,
            color: Color.fromARGB(255, 0, 114, 197),
            iconTheme: IconThemeData(
                color: Colors.white,
            ),
            actionsIconTheme: IconThemeData(
                color: Colors.white,
            ),
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
            buttonColor: Color.fromARGB(255, 0, 114, 197)
        );
    }

    CardTheme _buildCardTheme()
    {
        return CardTheme(

        );
    }

    ChipThemeData _buildChipTheme()
    {
        return ChipThemeData(
            backgroundColor: Color(0xFFFFFFFF),
            brightness: Brightness.dark,
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
            brightness: Brightness.dark,
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
            color: Color.fromARGB(255, 90, 90, 90),
            size: 24,
        );
    }

    InputDecorationTheme _buildInputDecorationTheme()
    {
        return InputDecorationTheme();
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
        return IconThemeData();
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
        );
    }

    Typography _buildTypography()
    {
        return Typography();
    }
}