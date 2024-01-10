import 'package:work_finger_print/helper/const.dart';

class DateHelper
{
List<String> days=['monday','tuesday','wednesday','thursday','friday','saturday','sunday'];
DateTime getDateTime(String date)
{
  return DateTime.parse(date);
}
int getDayDifference(DateTime dateTime1,DateTime dateTime2)
{
  return dateTime1.difference(dateTime2).inDays;
}
String getDateInString(DateTime date)
{
  return date.toIso8601String();
}
 getDateTimeByHour(DateTime date,int hour,int minute)
{
  DateTime dateTime=DateTime(
    date.year,date.month,date.day,hour,minute
  );
  return dateTime;
}
  String getTheDay(DateTime date)
  {
    return days[date.weekday-1];
  }
  int getHoursDifference(DateTime checkIn,DateTime checkOut)
  {
    int h=0;
    int inyear=checkIn.year;
    int inmonth=checkIn.month;
    int inday=checkIn.day;
    int inhour=checkIn.hour;
    int inminute=checkIn.minute;
    int outyear=checkOut.year;
    int outmonth=checkOut.month;
    int outday=checkOut.day;
    int outhour=checkOut.hour;
    int outminute=checkOut.minute;
    if(inminute==0)
    {
      inhour--;
    }
    if(inhour>9&&inhour<12&&inminute>15)
      inhour++;
    if(outminute>=45)
    {
      outhour++;
    }
    inminute=1;
    outminute=1;
    DateTime newCheckIn=DateTime(inyear,inmonth,inday,inhour,inminute);
    DateTime newCheckOut=DateTime(outyear,outmonth,outday,outhour,outminute);
    Duration diff=newCheckOut.difference(newCheckIn);
    h=diff.inHours;
    return h;
  }
  String getDate(DateTime date)
  {
    return date.toIso8601String().substring(0,10);
  }
  String getTimeOfDay(DateTime date)
 {
  int hour=date.hour;
  int minute=date.minute;
  //print(minute);
  return minute<10?'$hour:0$minute':'$hour:$minute';
}
List<int> getHourMinuteList(DateTime date)
{
  //List<int> hourMinuteList=[];
  int hour=date.hour;
  int minute=date.minute;
  return [hour,minute];
}

}