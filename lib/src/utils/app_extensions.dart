import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:task_tracker/src/utils/colors.dart';
import 'package:task_tracker/src/utils/utils.dart';

extension IntExtension on int?
{
    int validate({int value=0})
    {
      return this ??value;
    }
    Widget get kh => SizedBox(height: this?.toDouble(),);
    Widget get kw => SizedBox(width: this?.toDouble(),);
}
extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
extension TitleText on Text {
  Text text13W500() {
    return Text(
      data ?? '',
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
    );
  }
}

extension DescriptionText on String {
  Widget readMoreTextDefault({
    int trimLines = 2,
    Color colorClickableText = AppColors.accentDarkerColour,
    String trimCollapsedText = 'Show more',
    String trimExpandedText = ' Show less',
    TextStyle? moreStyle = const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
  }) {
    return ReadMoreText(
      this,
      trimMode: TrimMode.Line,
      trimLines: trimLines,
      colorClickableText: colorClickableText,
      trimCollapsedText: trimCollapsedText,
      trimExpandedText: trimExpandedText,
      moreStyle: moreStyle,
    );
  }
}
extension StringMultiplication on String {
  String multiply(String other) {
    try {
      final double thisValue = double.parse(this);
      final double otherValue = double.parse(other);
      return '${thisValue * otherValue}';
    } catch (e) {
      return 'Error: Invalid input';
    }
  }
}
extension DropdownLabelExtensions on int {
  String get todays {    
    switch (this) {
      case 0:
        return AppConst.selectDay;
      default:
        return toString();
    }
  }
}
extension TimestampExtension on int {
  /// Converts the timestamp to a formatted date string.
  String toISTFormattedDate() {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    final DateFormat formatter = DateFormat('d MMM yyyy hh:mm a');
    return formatter.format(dateTime);
  }
}

extension CustomDateTimeFormat on DateTime {
  String formattedDateTime() {
    final formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(this);
    return formattedDate;
  }
}
extension IndianDateExtensions on DateTime {
  
  String intDateFormat() {
    return "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year";
  }
}

extension TimestampExtensions on int {
  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }

  String toFormattedDate() {
    final dateTime = toDateTime();
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    return '$day-$month-$year';
  }

  String toFormattedDateTime() {
    final dateTime = toDateTime();
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day-$month-$year $hour:$minute';
  }
}
