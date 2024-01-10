// import 'package:work_finger_print/helper/const.dart';
// import 'package:work_finger_print/model/abstract_model.dart';
//
// class WorkTableModel extends Model
// {
//  final int workTableId;
//  final int workPlaceId;
//  final String workTableSymbol;
//  final String workTableDate;
//  final int? workTableWorkingHours;
//
//  WorkTableModel( {required this.workTableId,required  this.workPlaceId,
//   required  this.workTableSymbol,
//   required   this.workTableDate,this.workTableWorkingHours}):super(workPlaceId);
//  Map<String,dynamic> toMap()
//  {
//   Map<String,dynamic> workTableMap={
//    workTableIdColumn:workTableId,
//    workPlaceIdColumn:workPlaceId,
//    workTableDateColumn:workTableDate,
//    workTableSymbolColumn:workTableSymbol,
//   };
//   workTableMap.remove(workTableIdColumn);
//   return workTableMap;
//  }
// }