import 'package:work_finger_print/helper/const.dart';
import 'package:work_finger_print/model/abstract_model.dart';
class AttendanceModel extends Model
{
  final int attendanceId;
  final int workPlaceId;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final String attendanceSymbol;
  AttendanceModel({required this.attendanceId,required this.date,
    this.checkInTime, this.checkOutTime, required this.attendanceSymbol,required this.workPlaceId}):super(attendanceId);
   Map<String,dynamic> toMap()
  {
    Map<String,dynamic> attendanceMap={
      attendanceIdColumn:attendanceId,
      workPlaceIdColumn:workPlaceId,
      attendanceDateColumn:date,
      attendanceSymbolColumn:attendanceSymbol,
      checkInColumn:checkInTime,
      checkOutColumn:checkOutTime,
    };
    attendanceMap.remove(attendanceIdColumn);
    return attendanceMap;

  }
}