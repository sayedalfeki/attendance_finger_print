import 'package:flutter/material.dart';
import 'package:work_finger_print/database/attendance_operation.dart';
import 'package:work_finger_print/database/work_place_operation.dart';
import 'package:work_finger_print/helper/const.dart';
import 'package:work_finger_print/helper/helper_function.dart';
import 'package:work_finger_print/model/work_place_model.dart';
import '../helper/date.dart';
import '../model/attendance_model.dart';
import 'app_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBloc extends Cubit<AppState>
{
  AttendanceBloc():super(InitAppState());
  static AttendanceBloc instance(BuildContext context)=>BlocProvider.of(context);
  DateHelper dateHelper=DateHelper();
  AttendanceOperation afpOperation=AttendanceOperation();
  List<AttendanceModel> afpList=[];
  DateTime dateTime=DateTime.now();
  DateTime checkInDate=DateTime.now(),checkOutDate=DateTime.now();
  int month=DateTime.now().month;
  int year=DateTime.now().year;
  int yearIndex=0;
  int monthIndex=0;
  int symbolIndex=0;
  bool checked=false;
  List<bool> checkedList=[];
  List years=[];
  int shiftIndex=0;
  changeShiftIndex()
  {
    shiftIndex==0?shiftIndex=1:shiftIndex=0;
    emit(ChangeShiftIndex());
  }
  // check box method
  initCheckedList(){
    //checkedList.clear();
    for(int i=0;i<afpList.length;i++)
    checkedList.add(false);
   // emit(InitCheckedList());
  }
  changeChecked(int index,bool value)
  {
    checkedList[index]=value;
    emit(ChangeChecked());
  }
  // shift dropdown button
  initIndex(AttendanceModel attendanceModel)
  {
    symbolIndex=symbols.indexOf(attendanceModel.attendanceSymbol);
  }
  changeSymbol(String value)
  {
    symbolIndex=symbols.indexOf(value);
    emit(ChangeSymbol());
  }
  // adjust attendance shift
  int getWorkingHours(DateTime checkIn,DateTime checkOut)
  {
    int wHrs=dateHelper.getHoursDifference(checkIn, checkOut);
    return wHrs;
  }
 //  String getShift(DateTime checkIn,DateTime checkOut,{String? tableSymbol })
 //  {
 //    int wHrs=getWorkingHours(checkIn, checkOut);
 //    String strShift='O';
 //    // m or A shift with 6 hours
 //    if(wHrs<7)
 //    {
 //      // m shift
 //      if(checkIn.hour<12)
 //      {
 //        strShift='M${_getM6ShiftNum(checkIn)}';
 //      }
 //      else
 //      {
 //        strShift='A${_getA6ShiftNum(checkIn)}';
 //      }
 //    }
 //    // m or A shift with 7 hours
 //    else if(wHrs==7)
 //    {
 //      if(tableSymbol!.contains('X'))
 //      {
 //        strShift='(X${_getXShiftNum(checkIn)})-2';
 //      }
 //      else{
 //        if(checkIn.hour<12)
 //        {
 //          // strShift='M';
 //          // if(wHrs==5)
 //          //   strShift='(M)-2';
 //          // else if(wHrs==6)
 //          // {
 //          //   if(tableSymbol.contains('M'))
 //          //     strShift='M';
 //          //   else
 //          //     strShift='(M)-1';
 //          // }
 //          // else
 //          //   strShift='M';
 //          strShift='M${_getM7ShiftNum(checkIn)}';
 //        }
 //        else
 //        {
 //          strShift='A${_getA7ShiftNum(checkIn)}';
 //        }
 //      }
 //    }
 //    // x shift
 //    else if(wHrs>7&&wHrs<=9)
 //    {
 //      if(wHrs==8)
 //        strShift='(X${_getXShiftNum(checkIn)})-1';
 //      else
 //        strShift='X${_getXShiftNum(checkIn)}';
 //    }
 //    // long shift and night shift
 //    else if(wHrs>9&&wHrs<=12)
 //    {
 //      // L shift
 //      if(checkIn.hour<14)
 //      {
 //
 //        if(wHrs==10)
 //            strShift='(L${_getLShiftNum(checkIn)})-2';
 //          else if(wHrs==11)
 //            strShift='(L${_getLShiftNum(checkIn)})-1';
 //          else
 //          {
 //            strShift='L${_getLShiftNum(checkIn)}';
 //          }
 //
 //      }
 //      // N shift
 //      else
 //      {
 //        if(wHrs==10)
 //        strShift='(N${_getNShiftNum(checkIn)})-2';
 //        else if(wHrs==11)
 //          strShift='(N${_getNShiftNum(checkIn)})-1';
 //        else
 //          strShift='N${_getNShiftNum(checkIn)}';
 //      }
 //    }
 //    // AN shift
 //    else if(wHrs>12&&wHrs<19)
 //    {
 //      if(wHrs==16)
 //      {
 //        strShift='(A${_getANShiftNum(checkIn)}N${_getANShiftNum(checkIn)})-2';
 //      }
 //      else if(wHrs==17)
 //      {
 //        strShift='(A${_getANShiftNum(checkIn)}N${_getANShiftNum(checkIn)})-1';
 //      }
 //      else
 //      {
 //        strShift='A${_getANShiftNum(checkIn)}N${_getANShiftNum(checkIn)}';
 //      }
 //    }
 //    // LN shift
 //    else
 //    {
 //      if(wHrs==22)
 //      strShift='(L${_getLShiftNum(checkIn)}N${_getLShiftNum(checkIn)})-2';
 //      else if(wHrs==23)
 //        strShift='(L${_getLShiftNum(checkIn)}N${_getLShiftNum(checkIn)})-1';
 //      else
 //        strShift='L${_getLShiftNum(checkIn)}N${_getLShiftNum(checkIn)}';
 //    }
 //    return strShift;
 //  }
 //  int _getM6ShiftNum(DateTime checkInDate)
 //  {
 //    int hr=checkInDate.hour;
 //    if(checkInDate.minute==0)
 //      hr--;
 //    if((checkInDate.hour==10&&checkInDate.minute>15)||(checkInDate.hour==11&&checkInDate.minute>15))
 //      hr++;
 //    if(hr==7)
 //    {
 //      return 5;
 //    }
 //    else if(hr==8||hr==10) {
 //      return 1;
 //    }
 //    else
 //    {
 //      return 3;
 //    }
 //  }
 //  int _getM7ShiftNum(DateTime checkInDate)
 //  {
 //    int hr=checkInDate.hour;
 //    if(checkInDate.minute==0)
 //      hr--;
 //    if(checkInDate.hour==10&&checkInDate.minute>15)
 //      hr++;
 //    if(hr==7)
 //    {
 //      return 6;
 //    }
 //    else if(hr==8||hr==10) {
 //      return 2;
 //    }
 //    else
 //    {
 //      return 4;
 //    }
 //  }
 //  int _getA7ShiftNum(DateTime checkInDate)
 //  {
 //    int hr=checkInDate.hour;
 //    if(checkInDate.minute==0)
 //      hr--;
 //    if(hr==14)
 //    {
 //      return 2;
 //    }
 //    else
 //    {
 //      return 4;
 //    }
 //  }
 //  int _getA6ShiftNum(DateTime checkInDate)
 //  {
 //    int hr=checkInDate.hour;
 //    if(checkInDate.minute==0)
 //      hr--;
 //
 //    if(hr==14)
 //    {
 //      return 1;
 //    }
 //   else if(hr==12)
 //     return 6;
 //    else
 //    {
 //      return 3;
 //    }
 //  }
 //  int _getXShiftNum(DateTime checkInDate)
 //  {
 //   int hr=checkInDate.hour;
 //   if(checkInDate.minute==0)
 //     hr--;
 //   if(checkInDate.hour==10&&checkInDate.minute>15)
 //     hr++;
 //   if(hr==7)
 //   {
 //     return 3;
 //   }
 //   else if(hr==8||hr==10) {
 //     return 1;
 //   }
 //     else
 //     {
 //       return 2;
 //     }
 //
 //
 // }
 //  int _getLShiftNum(DateTime checkInDate)
 //  {
 //    int hr=checkInDate.hour;
 //    if(checkInDate.minute==0)
 //      hr--;
 //    if(checkInDate.hour==10&&checkInDate.minute>15)
 //      hr++;
 //    if(hr==7)
 //    {
 //      return 4;
 //    }
 //    else if(hr==8||hr==10) {
 //      return 1;
 //    }
 //    else
 //    {
 //      return 2;
 //    }
 //  }
 //  int _getNShiftNum(DateTime checkInDate)
 //  {
 //    int hr=checkInDate.hour;
 //    if(checkInDate.minute==0)
 //      hr--;
 //    if(hr==20)
 //    {
 //      return 1;
 //    }
 //
 //    else
 //    {
 //      return 2;
 //    }
//}
 //  int _getANShiftNum(DateTime checkInDate)
 //  {
 //    int hr=checkInDate.hour;
 //    if(checkInDate.minute==0)
 //      hr--;
 //    if(hr==14)
 //    {
 //      return 1;
 //    }
 //    else
 //    {
 //      return 2;
 //    }
 //  }
  String getShiftFromList(DateTime checkIn,DateTime checkOut)
  {
    String attendanceShift='';
    int checkInHour=_getCheckInHour(checkIn);
    int checkOutHour=_getCheckOutHour(checkOut);
    attendanceShift=allShifts[checkInHour][checkOutHour];
    return attendanceShift;
  }
  int _getCheckInHour(DateTime checkIn)
  {
    int hour=checkIn.hour;
    int minute=checkIn.minute;
    if((hour==10&&minute>15)||(hour==11&&minute>15)||(hour==22&&minute>15)||(hour==23&&minute>15))
      hour++;
    return hour;
  }
  int _getCheckOutHour(DateTime checkOut)
  {
    int hour=checkOut.hour;
    int minute=checkOut.minute;
    if(minute>=45)
      hour++;
    return hour;
  }
  // statistics
  int getMonthHour(List<AttendanceModel> attendanceList)
  {
    int monthHour=0;
    for(var attendanceModel in attendanceList)
    {
      String shiftSymbol=attendanceModel.attendanceSymbol;
      if(shiftSymbol.contains('O'))
      {
        monthHour+=0;
      }
      else if(shiftSymbol.contains('L')||shiftSymbol.contains('N'))
      {
        monthHour+=12;
      }
      else if(shiftSymbol.contains('X'))
      {
        monthHour+=9;
      }
      else if(shiftSymbol.contains('L1N1')||shiftSymbol.contains('L2N2'))
      {
        monthHour+=24;
      }
      else if(shiftSymbol.contains('M2')||shiftSymbol.contains('M4')||
          shiftSymbol.contains('A2')||shiftSymbol.contains('A4'))
      {
        monthHour+=7;
      }
      else
      {
        monthHour+=6;
      }
    }
    return monthHour;
  }
  int totalWorkingHour(List<AttendanceModel> attendanceList)
  {
    int totalAttendanceHour=0;
    for(var attendanceModel in attendanceList)
    {
      if(attendanceModel.checkInTime!=null&&attendanceModel.checkOutTime!=null) {
        DateTime checkInDate = DateTime.parse(attendanceModel.checkInTime!);
        DateTime checkOutDate = DateTime.parse(attendanceModel.checkOutTime!);
        int wHrs=getWorkingHours(checkInDate, checkOutDate);
        totalAttendanceHour+=wHrs;
      }
    }
    return totalAttendanceHour;
  }
  getMonthlyLateHours(List<AttendanceModel> attendanceModelList)
  {
    int monthlyLateHours=0;
    for(var attendanceModel in attendanceModelList)
    {
      if(attendanceModel.checkInTime!=null) {
        DateTime checkDate = DateTime.parse(attendanceModel.checkInTime!);
        int minute=checkDate.minute;
        if(minute>30)
          monthlyLateHours+=minute;
      }
    }
    return monthlyLateHours;
  }
  int numberOfHolidays(int monthHour,int attendanceHour)
  {
    int holidays=0;
    if(attendanceHour<monthHour)
    {
      int hoursDiff=monthHour-attendanceHour;
      holidays=hoursDiff~/7;
      if(hoursDiff%7>0)
        holidays++;
    }
    return holidays;
  }
 // date and time
  initYear()async
  {
    List<String> dates=await afpOperation.getAllDates();
    dates.forEach((element) {
      DateTime date=dateHelper.getDateTime(element);
      int year=date.year;
      if(years.isEmpty)
      {
        years.add(year);
      }
      else
      {
        if(!AppHelper.searchList(year, years))
          years.add(year);
      }

    });
    // afpList.forEach((element) {
    //   DateTime date=dateHelper.getDateTime(element.date);
    //   int year=date.year;
    //   if(years.length==0)
    //     years.add(year);
    //   else {
    //   if(!AppHelper.searchList(year, years))
    //     years.add(year);
    //   }
    // });
    emit(InitYearsState());
  }
  changeYear(int selectedYear)
  {
    year=selectedYear;
    yearIndex=years.indexOf(selectedYear);
    emit(ChangeYearState());
  }
  initMonthAndYear()
  {
 // month=DateTime.now().month;
 // year=DateTime.now().year;
  monthIndex=months.indexOf(month);
  yearIndex=years.indexOf(year);
  emit(InitMonthState());
}
  changeMonth(int selectedMonth)
  {
    month=selectedMonth;
    monthIndex=months.indexOf(selectedMonth);
    emit(ChangeMonthState());
  }
  changeDate(DateTime chooseDate,{bool timeSelected=false})
  {
    if(timeSelected)
      dateTime=chooseDate;
    else {
      DateTime newDate = DateTime(
          chooseDate.year, chooseDate.month, chooseDate.day, dateTime.hour,
          dateTime.minute);
      dateTime = newDate;
    }
  //date=dateHelper.getDate(dateTime);
  emit(ChangeDateState());
}
initCheckInDate(AttendanceModel attendanceModel)
{
  if(attendanceModel.checkInTime!=null)
  {
    checkInDate=dateHelper.getDateTime(attendanceModel.checkInTime!);
  }
}
  initCheckOutDate(AttendanceModel attendanceModel)
  {
    if(attendanceModel.checkOutTime!=null)
    {
      checkOutDate=dateHelper.getDateTime(attendanceModel.checkOutTime!);
    }
  }
  changeCheckInDate(DateTime chooseDate,{bool timeSelected=false})
  {
    checkInDate=chooseDate;
    // if(timeSelected)
    //   checkInDate=chooseDate;
    //   else
    //   {
    //     DateTime newDate = DateTime(
    //         chooseDate.year, chooseDate.month, chooseDate.day,checkInDate.hour,
    //         checkInDate.minute);
    //     checkInDate= newDate;
    //   }
      // DateTime newDate = DateTime(
      //     chooseDate.year, chooseDate.month, chooseDate.day, dateTime.hour,
      //     dateTime.minute);
      // dateTime = newDate;

    emit(ChangeDateState());
  }
  changeCheckOutDate(DateTime chooseDate,{bool timeSelected=false})
  {
    //checkOutDate = chooseDate;
    if(timeSelected)
        checkOutDate = chooseDate;
      else
      {
        DateTime newDate = DateTime(
            chooseDate.year, chooseDate.month, chooseDate.day,checkOutDate.hour,
            checkOutDate.minute);
        checkOutDate= newDate;
      }
      emit(ChangeDateState());
  }
 increaseDateByOne()
  {
  dateTime=dateTime.add(Duration(days: 1));
  emit(IncreaseDateState());
}
 //database
  Future<int> dateFoundId(String date)async
  {
    int id=await afpOperation.dateFoundId(date);
    return id;
  }
  addAttendanceTable(AttendanceModel attendanceModel)
  {
    afpOperation.insert(afpModel: attendanceModel);
    emit(RegestirationState());
  }
  updateAttendanceTable(int id,AttendanceModel attendanceModel)
  {
    afpOperation.update(id: id, afpModel: attendanceModel);
    emit(UpdateAttendance());
  }
  updateSymbol(int id,String symbol)
  {
    afpOperation.updateSymbol(id: id, symbol: symbol);
    emit(UpdateSymbolState());
  }
  Future<AttendanceModel> getAttendanceById(int id)async
  {
    AttendanceModel attendanceModel=await afpOperation.getAttendanceById(id);
    return attendanceModel;
  }
  registerCheckIn(AttendanceModel afpModel)
  {
    afpOperation.insert(afpModel: afpModel);
    emit(RegestirationState());
  }
  updateCheckIn(int id,String checkInTime)
  {
    afpOperation.updateCheckIn(id: id, checkInTime: checkInTime);
    emit(UpdateCheckIn());
  }
  updateCheckOut(int id,String checkOutTime)
  {
    afpOperation.updateCheckOut(id: id, checkOutTime: checkOutTime);
    emit(UpdateCheckOut());
  }
  deleteAFP(int id)
  {
    afpOperation.delete(id: id);
    emit(DeleteAttendanceState());
  }
  getAllAFP()async
  {
    afpList=await afpOperation.getAllFingerPrint(month,year);
    emit(GetAllAFPState());
  }
}

/*
* //    List<Map<String, List<int>>> sevenHoursShiftMorning=[{'M1':[8,14]},{'M2':[8,15]},{'M3':[9,15]},
//      {'M4':[9,16]},{'M5':[7,13]},{'M6':[7,14]},{'(M1)-2a':[8,12]},{'(M1)-2m':[10,14]},
//      {'(M2)-2m':[10,15]},{'(M2)-2a':[8,13]},{'(M3)-2m':[11,15]},{'(M3)-2a':[9,13]},
//      {'(M4)-2m':[8,12]},{'(M4)-2a':[9,14]},{'(M5)-2m':[9,13]},{'(M5)-2a':[7,11]},
//      {'(M6)-2m':[9,14]},{'(M6)-2a':[7,12]},{'(M1)-2m':[8,12]},{'(M1)-2a':[10,14]}
//    ];
//    List<Map<String, List<int>>> sevenHoursShiftAfter=[{'A1':[14,20]},{'A2':[14,21]},
// {'A3':[15,21]},{'A4':[13,20]},{'A6':[12,18]}];
//    List<Map<String, List<int>>> nineHoursShift=[{'X1':[8,17]},{'X2':[9,18]},{'X3':[7,16]}];
//    List<Map<String, List<int>>> longShift=[{'L1':[8,20]},{'L2':[9,21]}, {'L4':[7,19]}];
//    List<Map<String, List<int>>> nightShift=[{'N1':[20,32]},{'N2':[21,33]}];
//    List<Map<String, List<int>>> dayShift=[{'L1N1':[8,32]},{'L2N2':[9,33]}];
*
* */