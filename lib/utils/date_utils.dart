const List<String> koreanMonthWeekdays = ['일', '월', '화', '수', '목', '금', '토'];

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

String apiDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String koreanDate(DateTime value) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return '${value.month}월 ${value.day}일 ${weekdays[value.weekday - 1]}요일';
}

String shortDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$month.$day';
}

DateTime startOfWeek(DateTime value) {
  final day = dateOnly(value);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}
