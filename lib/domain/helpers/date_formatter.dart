import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  String dateFormatYMD(Timestamp datetime){
    var day = DateFormat.d().format(DateTime.fromMillisecondsSinceEpoch(datetime.millisecondsSinceEpoch));
    var month = DateFormat.M().format(DateTime.fromMillisecondsSinceEpoch(datetime.millisecondsSinceEpoch));
    var year = DateFormat.y().format(DateTime.fromMillisecondsSinceEpoch(datetime.millisecondsSinceEpoch));

    return "$day-$month-$year";
  }
}