import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  String formattedDate = DateFormat('hh:mm').format(dateTime);
  return formattedDate;
}
