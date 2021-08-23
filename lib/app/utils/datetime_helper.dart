import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeAgo;

//
import 'package:agree_n/app/enums/enums.dart';

class DateTimeHelper {
  static String calculateDurationValidate(DateTime validateDate) {
    final timeSpan = validateDate.difference(DateTime.now());
    final num totalMin = timeSpan.inMinutes;

    // 1 day = 1440 min
    int days = totalMin ~/ 1440;
    double remainingMinInDay = ((totalMin / 1440) - days) * 1440;
    int hours = remainingMinInDay ~/ 60;
    double remainingMinInHour = (remainingMinInDay / 60) - hours;
    int min = (remainingMinInHour * 60).round();

    return '$days Days ${hours}h ${min}m';
  }

  static String calculateTimeAgo(DateTime postDate, {String locale}) {
    if (locale != null) {
      if (locale == LanguageEnum.Vietnam) {
        timeAgo.setLocaleMessages('vi', timeAgo.ViMessages());
      }
      return timeAgo.format(postDate, locale: locale);
    }
    return timeAgo.format(postDate);
  }

  static String translateDateTime({DateTime dateTime,String langCode}) {
    String stringFormat = "MMM dd, yyyy";
    if (langCode == LanguageEnum.Vietnam) {
      stringFormat = "dd/MM/yyyy";
    }
    return DateFormat( stringFormat, langCode).format(dateTime);
  }
}
