import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_finger_print/bloc/app_states.dart';
import 'package:work_finger_print/bloc/attendance_bloc.dart';
import 'package:work_finger_print/helper/date.dart';
import 'package:work_finger_print/model/attendance_model.dart';
import '../../helper/const.dart';
import '../../helper/helper_function.dart';
import '../../widget/helper_widget.dart';
import 'check_history.dart';
class CheckPage extends StatelessWidget {
  const CheckPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppHelper appHelper=AppHelper(context);
    return BlocProvider(
      create: (context)=>AttendanceBloc(),
        //..initDateAndTime(),
      child: BlocConsumer<AttendanceBloc,AppState>(
        listener: (context,state){},
        builder:(context,state) {
          AttendanceBloc model=AttendanceBloc.instance(context);
          return Scaffold(
            appBar: AppBar(title: AppText('home page',fontWeight: FontWeight.normal,),
              actions: [
                IconButton(onPressed: ()async{
                  showDialog(context: context, builder:(context){
                  return AlertDialog(
                    content: WorkTableWidget(),);
                });
                }, icon:Icon(Icons.add_card,color: Colors.purple,))
                ,
              IconButton(onPressed: (){
                appHelper.navigate(CheckHistoryPage());
              }, icon:Icon(Icons.history,color: Colors.purple,))
            ],),
            body:CheckWidget(appHelper: appHelper,model: model,)
        );
        },
      ),
    );
  }
}
class CheckWidget extends StatelessWidget {
  CheckWidget({Key? key, required this.appHelper, required this.model})
      : super(key: key);
  final AttendanceBloc model;
  final AppHelper appHelper;
  DateHelper dateHelper = DateHelper();

  @override
  Widget build(BuildContext context) {
    TextEditingController timeController = TextEditingController(
        text:dateHelper.getTimeOfDay(model.dateTime));
    TextEditingController dateController = TextEditingController(
        text:dateHelper.getDate(model.dateTime));
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // date
            AppTextField(
                onTap: () async {
                  DateTime? choosedDate = await appHelper.showDate();
                  if (choosedDate != null) {
                    appHelper.showSnackBar(
                        '${choosedDate.hour}:${choosedDate.minute}');
                    model.changeDate(choosedDate);
                  }
                },
                controller: dateController, label: 'date', hint: 'enter date'),
            AppSizedBox(),
            AppTextField(
                onTap: () async {
                  TimeOfDay? time = await appHelper.showTime();
                  if (time != null) {
                    DateTime newDate=dateHelper.getDateTimeByHour(model.dateTime,time.hour,time.minute);
                    model.changeDate(newDate,timeSelected: true);
                    //appHelper.showSnackBar(time.hour.toString());
                  }
                },
                controller: timeController, label: 'time', hint: 'enter time'),
            AppSizedBox(),
            GestureDetector(
              onTap: ()
              {
                // DateTime checkIn=DateTime(2024,1,3,8,40);
                // DateTime checkOut=DateTime(2024,1,4,7,45);
                // int wh=model.getWorkingHours(checkIn, checkOut);
                // appHelper.showSnackBar('$wh');
                registerAttendance(model);
              },
              child: WrapableContainer(
                  child: AppText('register', color: Colors.white,),
                  color: Colors.teal
              ),
            ),
          ],
        ),
      ),
    );
  }

 void registerAttendance(AttendanceBloc modelBloc) async
  {
    // String strCheckDate = '';
    // int year = modelBloc.dateTime.year;
    // int month = modelBloc.dateTime.month;
    // int day = modelBloc.dateTime.day;
    // int hour = modelBloc.checkHour;
    // int minute = modelBloc.checkMinute;
    // DateTime checkDate = DateTime(
    //     year, month, day, hour, minute
    // );
   String date=dateHelper.getDate(modelBloc.dateTime);
    String strCheckDate = dateHelper.getDateInString(modelBloc.dateTime);
    int attendanceId = await modelBloc.dateFoundId(date);
    // this date is registered
    if (attendanceId != -1) {
      AttendanceModel attendanceModel = await modelBloc.getAttendanceById(
          attendanceId);
      // checked in
      if (attendanceModel.checkInTime != null) {
        modelBloc.updateCheckOut(attendanceId, strCheckDate);
      }
      else {
        modelBloc.updateCheckIn(attendanceId, strCheckDate);
      }
    }

    // the date not registered
    else {
      DateTime theDayBefore = modelBloc.dateTime.subtract(Duration(days: 1));
      String strDate = dateHelper.getDate(theDayBefore);
      int id = await modelBloc.dateFoundId(strDate);
      // the day before is registered
      if (id != -1)
      {
        AttendanceModel attendanceModel = await modelBloc.getAttendanceById(id);
        if (attendanceModel.checkInTime != null &&
            attendanceModel.checkOutTime == null)
        {
          modelBloc.updateCheckOut(id,strCheckDate);
        }
        else
        {
          AttendanceModel afpModel = AttendanceModel
            (
            attendanceId: 1,
            month: modelBloc.dateTime.month,
            date: date,
            checkInTime: strCheckDate,
            attendanceSymbol: 'O',

          );
          modelBloc.addAttendanceTable(afpModel);
        }
      }
      else
      {
        AttendanceModel afpModel = AttendanceModel
          (
          attendanceId: 1,
          month: modelBloc.dateTime.month,
          date:date,
          checkInTime: strCheckDate,
          attendanceSymbol: 'O',
        );
        modelBloc.addAttendanceTable(afpModel);
      }
    }
    appHelper.showSnackBar('registered');
  }
}
class WorkTableWidget extends StatelessWidget {
   WorkTableWidget({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    AppHelper appHelper=AppHelper(context);
    DateHelper dateHelper=DateHelper();
    return BlocProvider(
      create: (context)=>AttendanceBloc(),
      child: BlocConsumer<AttendanceBloc,AppState>(
        listener: (context,state){},
        builder:(context,state) {
          AttendanceBloc modelBloc=AttendanceBloc.instance(context);
          TextEditingController dateController=TextEditingController(text:
          dateHelper.getDate(modelBloc.dateTime));
          return Container(
          width: double.infinity,
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: AppText('add your work table',color: Colors.teal,)),
              AppSizedBox(),
              Expanded(
                flex: 1,
                child: AppTextField(
                    onTap: ()async{
                      DateTime? date=await appHelper.showDate();
                      if(date!=null)
                      {
                        modelBloc.changeDate(date);
                
                      }
                    },
                    controller:dateController, label:'date', hint:''),
              ),
              AppSizedBox(width: 10),
              Expanded(
                flex: 1,
                child: DropdownButton<String>(
                    value:symbols[modelBloc.symbolIndex],
                    items:
                    symbols.map((value){
                      return DropdownMenuItem(
                          value: value,
                          child: AppText(value));
                    }).toList()
                    ,
                    onChanged:(value){
                       modelBloc.changeSymbol(value!);
                    }),
              ),
              AppSizedBox(),
              GestureDetector(
                onTap: () async {
                   String date=dateHelper.getDate(modelBloc.dateTime);
                   int id=await modelBloc.dateFoundId(date);
                     appHelper.showSnackBar('$id');
                     if(id==-1){
                       AttendanceModel attendanceModel=AttendanceModel(attendanceId:1,
                           month:modelBloc.dateTime.month,
                           date:date,
                           attendanceSymbol:symbols[modelBloc.symbolIndex]);
                       modelBloc.addAttendanceTable(attendanceModel);
                     }
                     else
                     {
                       modelBloc.updateSymbol(id,symbols[modelBloc.symbolIndex]);
                     }
                   modelBloc.increaseDateByOne();
                },
                  child: WrapableContainer(
                      color: Colors.teal,
                      child: AppText('add',color: Colors.white,)))
            ],
          ),
        );
        },
      ),
    );
  }
}


