import 'package:supercharged/supercharged.dart';

class TimeUtils {
  static String secondsToHumanReadable(int sec) {
    String minutes = (sec ~/ 60).toString();
    String seconds = (sec % 60).toString();
    if (seconds.length == 1) seconds = "0$seconds";
    if (minutes.length == 1) minutes = "0$minutes";
    if (sec > 1.hours.inSeconds) {
      String hours = (int.parse(minutes) ~/ 60).toString();
      minutes = (int.parse(minutes) - 1.minutes.inSeconds.toInt()).toString();
      if (hours.length == 1) hours = "0$hours";
      if (minutes.length == 1) minutes = "0$minutes";
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  static String dateTimetoHumanReadable(DateTime dt) {
    String hour = (dt.hour > 12 ? dt.hour - 12 : dt.hour).toString();
    String minutes = dt.minute.toString();
    if (hour.length == 1) hour = "0$hour";
    if (minutes.length == 1) minutes = "0$minutes";
    return "$hour:$minutes";
  }
}
