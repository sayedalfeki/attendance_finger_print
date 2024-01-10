// import 'package:work_finger_print/database/abstract_operation.dart';
// import 'package:work_finger_print/database/attendance_database.dart';
// import 'package:work_finger_print/model/abstract_model.dart';
// import 'package:work_finger_print/model/work_table_model.dart';
// import '../helper/const.dart';
// class WorkTableOperation extends CrudOperation
// {
//   final _database=AttendanceDatabase.instance.database;
//   @override
//   void insert(Model workTableModel)async {
//     final db= await _database;
//     db.insert(workTableName,workTableModel.toMap());
//   }
//   @override
//   void delete( int id) async {
//     final db= await _database;
//     db.delete(workTableName,where: '$workTableIdColumn=?',whereArgs: [id]);
//   }
//   @override
//   void update( int id,Model workTableModel)async {
//     final db= await _database;
//     db.update(workTableName,workTableModel.toMap(),where: '$workTableIdColumn=?',whereArgs: [id]);
//   }
//
//   @override
//   Future<List<WorkTableModel>> getAll() async{
//     final db= await _database;
//     List<WorkTableModel> workTableList=[];
//     List<Map> workTableMap=await db.query(workTableName);
//     if(workTableMap.isNotEmpty)
//     {
//       workTableList=List.generate(workTableMap.length, (index){
//         return WorkTableModel(
//             workTableId:workTableMap[index][workTableIdColumn],
//             workPlaceId:workTableMap[index][workPlaceIdColumn],
//             workTableDate: workTableMap[index][workTableDateColumn],
//             workTableSymbol: workTableMap[index][workTableSymbolColumn],
//
//         );
//       });
//     }
//     return workTableList;
//   }
//
//
//
//
//
//
// }