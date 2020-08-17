class TimeUtils {
  static String secondsToHumanReadable(int sec) {
    String minutes = (sec ~/ 60).toString();
    String seconds = (sec % 60).toString();
    if (seconds.length == 1) seconds = "0$seconds";
    if (minutes.length == 1) minutes = "0$minutes";
    return "$minutes:$seconds";
  }
}
