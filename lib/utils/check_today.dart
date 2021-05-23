// check if date is today
bool isToday(DateTime date, {DateTime referenceDate}) {
  DateTime now = referenceDate ?? DateTime.now();

  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return true;
  }

  return false;
}
