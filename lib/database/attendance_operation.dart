

import 'package:work_finger_print/database/attendance_database.dart';
import 'package:work_finger_print/model/attendance_model.dart';
import '../helper/const.dart';


class AttendanceOperation
{
  final _database=AttendanceDatabase.instance.database;
  void insert({required AttendanceModel afpModel})async {
    final db= await _database;
    db.insert(attendanceTableName,afpModel.toMap());
  }
  void delete({required int id})async {
    final db= await _database;
    db.delete(attendanceTableName,where: '$attendanceIdColumn=?',whereArgs: [id]);
  }
  void update({required int id,required AttendanceModel afpModel})async {
    final db= await _database;
    db.update(attendanceTableName,afpModel.toMap(),where: '$attendanceIdColumn=?',whereArgs: [id]);
  }
  void updateCheckIn({required int id,required String checkInTime})async {
    final db= await _database;
    db.update(attendanceTableName,{checkInColumn:checkInTime},where: '$attendanceIdColumn=?',whereArgs: [id]);
  }
  void updateCheckOut({required int id,required String checkOutTime})async {
    final db= await _database;
    db.update(attendanceTableName,{checkOutColumn:checkOutTime},where: '$attendanceIdColumn=?',whereArgs: [id]);
  }
  void updateSymbol({required int id,required String symbol})async {
    final db= await _database;
    db.update(attendanceTableName,{attendanceSymbolColumn:symbol},where: '$attendanceIdColumn=?',whereArgs: [id]);
  }
  Future<int> getLastId()async
  {
    final db= await _database;
    List<Map> map=await db.query(attendanceTableName,orderBy: '$attendanceIdColumn desc',limit: 1);
    int id=map[0][attendanceIdColumn];
    return id;
  }
  Future<List<AttendanceModel>> getAllFingerPrint({required int month,required int year,required int workPlaceId}) async{
    String newMonth=month<10?'0$month':'$month';
    String searchedDate='$year-$newMonth';
    final db= await _database;
    List<AttendanceModel> afpList=[];
    List<Map> afpMap=await db.query(attendanceTableName,where: '$attendanceDateColumn like "$searchedDate%" AND '
        '$workPlaceIdColumn=$workPlaceId',
        orderBy:attendanceDateColumn);
    if(afpMap.isNotEmpty)
    {
      afpList=List.generate(afpMap.length, (index){
        return AttendanceModel(
            attendanceId:afpMap[index][attendanceIdColumn],
            workPlaceId:afpMap[index][workPlaceIdColumn],
            date: afpMap[index][attendanceDateColumn],
            attendanceSymbol: afpMap[index][attendanceSymbolColumn],
            checkInTime: afpMap[index][checkInColumn],
            checkOutTime: afpMap[index][checkOutColumn],
        );
      });
    }
    return afpList;
  }
  // Future<List<String>> getAllCheckInDates(int month) async{
  //   final db= await _database;
  //   List<String> afpList=[];
  //   List<Map> afpMap=await db.query(attendanceTableName,where: '$monthColumn=?',
  //       whereArgs: [month],orderBy:attendanceDateColumn);
  //   if(afpMap.isNotEmpty)
  //   {
  //     afpList=List.generate(afpMap.length, (index){
  //       if(afpMap[index][checkInColumn]!=null)
  //          return afpMap[index][checkInColumn];
  //       return '';
  //     });
  //   }
  //   return afpList;
  // }
 Future<int> dateFoundId(String date,int workPlaceId)async
 {
   int id=-1;
   final db= await _database;
   List<Map> afpMap=await db.query(attendanceTableName,where: '$attendanceDateColumn=? AND $workPlaceIdColumn=?',whereArgs: [date,workPlaceId]);
   if(afpMap.isNotEmpty)
   {
     id=afpMap[0][attendanceIdColumn];
   }
   return id ;
 }
 Future<AttendanceModel> getAttendanceById(int attendanceId)async
 {
   final db=await _database;
   List<Map> attendanceMap=await db.query(attendanceTableName,where: '$attendanceIdColumn=?',
       whereArgs: [attendanceId]);
   return AttendanceModel(attendanceId:attendanceMap[0][attendanceIdColumn],
         workPlaceId:attendanceMap[0][workPlaceIdColumn],
        date: attendanceMap[0][attendanceDateColumn],
         attendanceSymbol:attendanceMap[0][attendanceSymbolColumn],
        checkInTime: attendanceMap[0][checkInColumn],
        checkOutTime: attendanceMap[0][checkOutColumn]
     );


 }
Future<List<String>> getAllDates()async
{
  List<String> dates=[];
  final db=await _database;
  List<Map> attendanceMap=await db.query(attendanceTableName,columns: [attendanceDateColumn]);
  if(attendanceMap.isNotEmpty)
  {
    dates=List.generate(attendanceMap.length, (index){
      return attendanceMap[index][attendanceDateColumn];
    });
  }
  return dates;
}
}