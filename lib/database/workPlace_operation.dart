import '../database/attendance_database.dart';
import '../helper/const.dart';
import '../model/workPlace_model.dart';

class WorkPlaceOperation
{
  final  _database=AttendanceDatabase.instance.database;
  insert(WorkPlaceModel wpModel)async
  {
    final db=await _database;
    db.insert(workPlaceTableName,wpModel.toMap());
  }
  Future<int> getId(String wpName)async
  {
    final db=await _database;
    int id=-1;
    List<Map> wpMap=await db.query(workPlaceTableName,
        where: '$workPlaceNameColumn=?',whereArgs: [wpName]);
    if(wpMap.isNotEmpty)
    {
      id=wpMap[0][workPlaceIdColumn];
    }
    return id;
  }
   Future<List<String>> getWorkPlacesNames()async
  {
    List<String> wpList=[];
    final db=await _database;
    List<Map<String,dynamic>> wpMap=await db.query(workPlaceTableName);
    wpList=List.generate(wpMap.length, (index){
      return wpMap[index][workPlaceNameColumn];
    });
    return wpList;
  }
}