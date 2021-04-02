class Converter {
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  convertNumberToMonthName(int i) {
    return months[i - 1];
  }

  convertNumberToWeekDayName(int i) {
    return days[i - 1];
  }

  String formateTime(String hour, int miniute, String amOrpm) {
    return miniute < 10
        ? hour + ":0" + miniute.toString() + " " + amOrpm
        : hour + ":" + miniute.toString() + " " + amOrpm;
  }

  convert24To12(int h, int m) {
    if (h == 0) return formateTime("12", m, "AM");
    if (h < 12) return formateTime(h.toString(), m, "AM");
    if (h == 12) return formateTime("12", m, "PM");
    if (h > 12) return formateTime((h - 12).toString(), m, "PM");
  }
}
