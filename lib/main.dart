import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_finger_print/database/attendance_operation.dart';
import 'package:work_finger_print/helper/date.dart';
import 'package:work_finger_print/model/attendance_model.dart';

import 'view/check/check_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   String dir=Directory.current.path;
  //   String scriptDir = File(Platform.script.toFilePath()).parent.path;
  //   print(scriptDir);
  //   List<List<String>> excelData = await excelTo2DArray();
  //   print(excelData);
  // } catch (e) {
  //   print('Error: $e');
  // }
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CheckPage(),
  ));
}
// C:\Users\HP\Desktop
Future<List<List<String>>> excelTo2DArray() async {
  String fileName = 'shifts.xlsx';

  //var bytes = File('C:\\Users\\HP\\Desktop\\shifts.xlsx').readAsBytesSync();
  ByteData data = await rootBundle.load('assets/shifts.xlsx');
  var bytes = data.buffer.asUint8List();
  //var bytes = data.buffer.asUint8List();

  var excel = Excel.decodeBytes(bytes);

  if (excel == null) {
    print('Error: Failed to decode Excel file');
    return [];
  }

  List<List<String>> result = [];

  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows) {
      List<String> rowData = [];
      for (var cell in row) {
        rowData.add(cell!.value.toString());
      }
      result.add(rowData);
    }
  }

  return result;
}
