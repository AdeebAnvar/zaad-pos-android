import 'package:intl/intl.dart';
import 'package:pos_app/data/utils/date_time_utils.dart';

extension StringExtensions on String? {
  // String capitalize() {
  //   if (this.isEmpty) return this;
  //   return this[0].toUpperCase() + this.substring(1);
  // }
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return emailRegex.hasMatch(this ?? "");
  }

  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  bool isLocalFile() {
    return this!.startsWith('/') || this!.startsWith('file://');
  }

  String toDateOnly({bool isViewFormat = false}) {
    if (isNullOrEmpty()) {
      return "";
    }

    try {
      DateTime dateAndTime;

      // First try to parse with DateFormat for dd-MM-yyyy format
      try {
        dateAndTime = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(this!);
      } catch (e) {
        // If that fails, try parsing as ISO format
        try {
          dateAndTime = DateTime.parse(this!);
        } catch (e) {
          // If both fail, try parsing as dd-MM-yyyy only
          dateAndTime = DateFormat("dd-MM-yyyy").parse(this!);
        }
      }

      final format = DateFormat(isViewFormat ? defaultDateViewFormat : defaultDateFormat);

      return format.format(dateAndTime);
    } catch (e) {
      print("Date parsing error: $e");
      return "";
    }
  }

  String toTimeOnly({bool showAmPm = false}) {
    if (this == null) return ''; // Handle null safety

    try {
      DateTime dateAndTime = DateTime.parse(this!);

      // Use "h:mm:ss a" for 12-hour format with AM/PM
      // Use "HH:mm:ss" for 24-hour format
      String format = showAmPm ? "h:mm a" : "HH:mm:ss";
      String time = DateFormat(format).format(dateAndTime);

      return time;
    } catch (e) {
      return ''; // Return empty string if parsing fails
    }
  }

  String replaceLeadingZero() {
    if (!isNullOrEmpty()) {
      return this!.replaceAll(RegExp(r'^0+(?=.)'), '');
    } else {
      return "";
    }
  }

  String toServerDateOnly() {
    DateTime dateAndTime = DateTime.parse(this!);
    final DateFormat format;
    format = DateFormat(defaultDateFormat);
    final date = format.format(dateAndTime);
    return date;
  }

  String toTimeWithAmPm() {
    if (isNullOrEmpty() || this == "00:00:00") {
      return "";
    } else {
      DateTime dateAndTime = DateTime.parse("1990-01-01 ${this!}");
      final format = DateFormat('hh:mm a');
      final date = format.format(dateAndTime);
      return date;
    }
  }

  String toDateTimeWithAmPm() {
    if (isNullOrEmpty() || this == "00:00:00") {
      return "";
    } else {
      DateTime dateAndTime = DateTime.parse(this!);
      final format = DateFormat('dd-MM-yyyy hh:mm a');
      final date = format.format(dateAndTime);
      return date;
    }
  }

  String toTime24h() {
    DateTime dateAndTime = DateFormat("$defaultDateFormat hh:mm a").parse("01-01-1990 ${this!}"); //eg="01-01-1990 02:04 PM"
    final format = DateFormat('HH:mm');
    final date = format.format(dateAndTime);
    return date;
  }

  String setIfNullEmpty() {
    return this == null ? "" : this!;
  }
}

extension IntExtensions on int? {
  bool isNullOrZero() {
    return this == null || this == 0;
  }

  bool isGreaterThanZero() {
    return this != null && this! > 0;
  }

  String setIfNullEmpty() {
    return this == null ? "" : toString();
  }

  int getDaysInMonth(int year, int month) {
    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))) {
      return 29; // February in a leap year
    }
    return daysInMonth[month - 1];
  }

  String toYearAndMonth() {
    int years = 0;
    int months = 0;
    int days = 0;
    if (!isNullOrZero()) {
      // Start from a base date
      DateTime startDate = DateTime(1, 1, 1); // Starting from year 1, month 1, day 1

      // Days to be added
      int daysToAdd = this!;

      // Calculate the end date
      DateTime endDate = startDate.add(Duration(days: daysToAdd));

      // Calculate years, months, and days
      years = endDate.year - startDate.year;
      months = endDate.month - startDate.month;
      days = endDate.day - startDate.day;

      if (days < 0) {
        // If days are negative, subtract one month and calculate days again
        months -= 1;
        // Handle month roll-back
        if (months < 0) {
          years -= 1;
          months += 12; // Roll back to December of the previous year
        }
        DateTime daysInPrevMonth = startDate.add(Duration(days: daysToAdd - days));
        days = daysInPrevMonth.day;
      }

      // Correct for the case where endDate.day is less than startDate.day
      if (endDate.day < startDate.day) {
        var tempDate = DateTime(endDate.year, endDate.month, 0); // Last day of the previous month
        days += tempDate.day;
      }
    }

    print("Years: $years, Months: $months, Days: $days");
    return "$years Y $months M $days D ";
  }
}

extension DoubleExtensions on double? {
  bool isNullOrZero() {
    return this == null || this == 0 || this == 0.0;
  }

  bool isGreaterThanZero() {
    return this != null && this! > 0;
  }
}

String formatDateinDdMmYYYY(String dateTimeStr) {
  // Handle ISO format dates first
  try {
    DateTime parsedDateTime = DateTime.parse(dateTimeStr);
    return DateFormat('MMM dd, yyyy hh:mm a').format(parsedDateTime);
  } catch (e) {
    // If not ISO format, proceed with other format handling
  }

  // First, separate date and time if present
  List<String> parts = dateTimeStr.split(':');
  String date = parts[0];
  String time = parts.length > 1 ? '${parts[1]}:${parts[2]}' : '';

  // List of possible date formats in descending priority
  final List<String> possibleFormats = [
    'dd-MM-yyyy', // Example: 19-12-2024
    'yyyy-MM-dd', // Example: 2024-12-19
    'MM/dd/yyyy', // Example: 12/19/2024
    'dd/MM/yyyy', // Example: 19/12/2024
    'dd MMM yyyy', // Example: 19 Dec 2024
    'Entry_Date: dd-MM-yyyy', // Example: Entry_Date: 19-12-2024
  ];

  DateTime? parsedDate;

  // Try parsing the date with each format
  for (var format in possibleFormats) {
    try {
      // Remove any 'Entry_Date: ' prefix if present
      String cleanDate = date.replaceAll('Entry_Date: ', '').trim();
      parsedDate = DateFormat(format).parseStrict(cleanDate);
      break; // Break if successful
    } catch (e) {
      continue; // Try next format if current fails
    }
  }

  if (parsedDate == null) {
    return dateTimeStr; // Return original if parsing fails
  }

  // Format the date part
  String formattedDate = DateFormat('MMM dd, yyyy').format(parsedDate);

  // If time is present, parse and format it
  if (time.isNotEmpty) {
    try {
      List<String> timeParts = time.split(':');
      int hours = int.parse(timeParts[0].trim());
      int minutes = int.parse(timeParts[1].trim());

      // Create DateTime with both date and time
      DateTime dateTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        hours,
        minutes,
      );

      // Format with both date and time
      return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      // If time parsing fails, return just the formatted date
      return formattedDate;
    }
  }

  return formattedDate;
}

String formatTimeinAmPm(String time) {
  try {
    // Parse the input time string
    final DateTime parseTime = DateFormat('HH:mm:ss').parse(time.trim());

    // Format to desired output: hh:mm a
    return DateFormat('hh:mm a').format(parseTime);
  } catch (e) {
    // Log error and return original time if parsing fails
    print('Failed to parse time: $time. Error: $e');
    return time;
  }
}
