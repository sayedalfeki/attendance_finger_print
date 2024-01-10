import 'package:flutter/material.dart';

import '../widget/helper_widget.dart';

class AppHelper{
  final BuildContext context;
  AppHelper(this.context);
  printData(String data)
  {
    print(data);
  }
  showSnackBar(String data)
  {
    ScaffoldMessenger.of(context).
    showSnackBar(SnackBar(content: AppText(data,color: Colors.white),backgroundColor: Colors.cyan,));
  }
  navigate(Widget route)
  {
    Navigator.push(context,MaterialPageRoute(builder: (context)=>route));
  }
  Future<DateTime?>? showDate()async
  {
   DateTime? date=await  showDatePicker(
        currentDate: DateTime.now(), context: context,
       firstDate:DateTime(2020), lastDate:DateTime(2030));
   return date;
  }
  Future<TimeOfDay?>? showTime()async
  {
      TimeOfDay? time=await showTimePicker(
          context: context,initialTime: TimeOfDay.now() );
    return time;
  }
  static bool searchList(int item,List yearsList)
  {
    bool found=false;
    for (int i=0;i<yearsList.length;i++)
    {
      if(yearsList[i]==item)
        found=true;
    }
    return found;
  }
}