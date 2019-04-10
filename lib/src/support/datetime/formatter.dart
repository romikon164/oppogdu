import 'package:intl/intl.dart';

class DateTimeFormatter
{
    static DateTime dateTimeFromSeconds(int seconds)
    {
        if(seconds == null) {
            return null;
        } else {
            return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
        }
    }

    static String format(DateTime dateTime, {String pattern = "dd.MM.yyyy"})
    {
        return DateFormat(pattern).format(dateTime);
    }
}