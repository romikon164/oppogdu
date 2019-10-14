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

    static String monthText(DateTime date)
    {
        String monthText;

        switch (date.month) {
            case  1: monthText = 'января'  ; break;
            case  2: monthText = 'февраля' ; break;
            case  3: monthText = 'марта'   ; break;
            case  4: monthText = 'апреля'  ; break;
            case  5: monthText = 'мая'     ; break;
            case  6: monthText = 'июня'    ; break;
            case  7: monthText = 'июля'    ; break;
            case  8: monthText = 'августа' ; break;
            case  9: monthText = 'сентября'; break;
            case 10: monthText = 'октября' ; break;
            case 11: monthText = 'ноября'  ; break;
            case 12: monthText = 'декабря' ; break;
        }

        return monthText;
    }

    static String weekdayText(DateTime date)
    {
        String weekdayText;

        switch (date.weekday) {
            case 1: weekdayText = 'пн'; break;
            case 2: weekdayText = 'вт'; break;
            case 3: weekdayText = 'ср'; break;
            case 4: weekdayText = 'чт'; break;
            case 5: weekdayText = 'пт'; break;
            case 6: weekdayText = 'сб'; break;
            case 7: weekdayText = 'вс'; break;
        }

        return weekdayText;
    }
}