import 'package:flutter/material.dart';

class Utils
{
    static Color avatarBackgroundColor(String l)
    {
        l = l.toLowerCase();
        if(l == "а" || l == "э" || l == "ю") {
            return Colors.amberAccent;
        } else if(l == "б") {
            return Colors.blue;
        } else if(l == "г" || l == "д" || l == "е" || l == "ё") {
            return Colors.deepOrangeAccent;
        } else if(l == "ж" || l == "з") {
            return Colors.blue;
        } else if(l == "и" || l == "й" || l == "к") {
            return Colors.indigoAccent;
        } else if(l == "л" || l == "м" || l == "н") {
            return Colors.lightBlueAccent;
        } else if(l == "о") {
            return Colors.orangeAccent;
        } else if(l == "п") {
            return Colors.pinkAccent;
        } else if(l == "р" || l == "с") {
            return Colors.redAccent;
        } else if(l == "т" || l == "у" || l == "ф" || l == "х") {
            return Colors.tealAccent;
        } else if(l == "ц" || l == "ч" || l == "ь" || l == "ъ") {
            return Colors.cyanAccent;
        } else if(l == "ш" || l == "щ" || l == "я") {
            return Colors.yellowAccent;
        } else {
            return Colors.lightBlueAccent;
        }
    }
}