import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_finger_print/business_layer/bloc/workPlace_bloc.dart';
import 'package:work_finger_print/business_layer/states/workPlace_state.dart';
import 'package:work_finger_print/model/workPlace_model.dart';
import '../../business_layer/bloc/attendance_bloc.dart';
import '../../business_layer/states/attendance_states.dart';
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
      create: (mainContext)=>WorkPlaceBloc()..getLanguage()..getWorkPlaces(),
        //..initDateAndTime(),
      child: BlocConsumer<WorkPlaceBloc,WorkPlaceState>(
        listener: (mainContext,mainState){},
        builder:(mainContext,mainState) {
          WorkPlaceBloc workPlaceBloc=WorkPlaceBloc.instance(mainContext);
         // workPlaceBloc.getWorkPlaces();
          List<String> places=workPlaceBloc.places;
         // appHelper.printData(places.toString());
          return BlocProvider(
            create: (context)=>AttendanceBloc(),
            child: BlocConsumer<AttendanceBloc,AttendanceState>(
              listener:(context,state){} ,
              builder:(context,state) {
                AttendanceBloc model=AttendanceBloc.instance(context);
                return Scaffold(
                appBar: AppBar(title: AppText(workPlaceBloc.homePage,fontWeight: FontWeight.normal,),
                  actions: [
                    IconButton(onPressed: ()async{
                      if(places.isEmpty)
                      {
                        AppHelper(context).showSnackBar('${workPlaceBloc.addWorkPlace} ${workPlaceBloc.first}');
                        return;
                      }
         int workPlaceId=await workPlaceBloc.getWorkPlaceId(places[workPlaceBloc.placeIndex]);
                      String place=places[workPlaceBloc.placeIndex];
                      showDialog(context: context, builder:(context){
                      return AlertDialog(
                        content: WorkTableWidget(workPlaceId: workPlaceId,workPlace: place,
                        workPlaceBloc: workPlaceBloc,),);
                    });
                    }, icon:Icon(Icons.add_card,color: Colors.purple,))
                    ,
                  IconButton(onPressed: ()async{
                    if(places.isEmpty)
                    {
                      AppHelper(context).showSnackBar('${workPlaceBloc.addWorkPlace} ${workPlaceBloc.first}');
                      return;
                    }
                    int workPlaceId=await workPlaceBloc.getWorkPlaceId(places[workPlaceBloc.placeIndex]);
                    String place=places[workPlaceBloc.placeIndex];
                    //appHelper.showSnackBar(place);
                    appHelper.navigate(CheckHistoryPage(workPlaceId: workPlaceId,
                    workPlace:place,
                    ));
                  }, icon:Icon(Icons.history,color: Colors.purple,))
                ],),
                body:CheckWidget(appHelper: appHelper,model: model,workPlaceBloc: workPlaceBloc,),
                  drawer: AppDrawerWidget(workPlaceBloc: workPlaceBloc),
                      );
              },
            ),
          );
        },
      ),
    );
  }
}
class CheckWidget extends StatelessWidget {
  CheckWidget({Key? key, required this.appHelper,required this.workPlaceBloc ,required this.model})
      : super(key: key);
  final WorkPlaceBloc workPlaceBloc;
  final AttendanceBloc model;
  final AppHelper appHelper;
  DateHelper dateHelper = DateHelper();
  @override
  Widget build(BuildContext context) {
    List<String> places=workPlaceBloc.places;
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
            //work places
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSpacer(width: 10),
                 places.isEmpty?AppText(workPlaceBloc.addWorkPlace): DropdownButton<String>(
                      value:places[workPlaceBloc.placeIndex],
                      items: places.map((e) {
                    return DropdownMenuItem(
                        value: e,
                        child: AppText(e));
                  }).toList()
                      , onChanged:(value){
                        workPlaceBloc.changePlaceIndex(value!);
                 }),
                  AppSpacer(width: 10),
                  IconButton(onPressed: (){
                      showDialog(context: context, builder:(context){
                        return AlertDialog(
                          content: WorkPlaceWidget(workPlaceBloc: workPlaceBloc,),
                        );
                      }).then((value) => workPlaceBloc.getWorkPlaces());
                  }, icon:Icon(Icons.add))
                ],
              ),
            AppSpacer(height: 50),
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
                controller: dateController, label:workPlaceBloc.dateConst, hint: ''),
            AppSpacer(),
            AppTextField(
                onTap: () async {
                  TimeOfDay? time = await appHelper.showTime();
                  if (time != null) {
                    DateTime newDate=dateHelper.getDateTimeByHour(model.dateTime,time.hour,time.minute);
                    model.changeDate(newDate,timeSelected: true);
                    //appHelper.showSnackBar(time.hour.toString());
                  }
                },
                controller: timeController, label:workPlaceBloc.timeConst, hint: ''),
            AppSpacer(),
            GestureDetector(
              onTap: ()
              {
                // DateTime checkIn=DateTime(2024,1,3,8,40);
                // DateTime checkOut=DateTime(2024,1,4,7,45);
                // int wh=model.getWorkingHours(checkIn, checkOut);
                // appHelper.showSnackBar('$wh');
                registerAttendance(model,workPlaceBloc);
              },
              child: AppContainer(
                  child: AppText(workPlaceBloc.registerButton, color: Colors.white,),
                  color: Colors.teal
              ),
            ),
          ],
        ),
      ),
    );
  }

 void registerAttendance(AttendanceBloc modelBloc,WorkPlaceBloc workPlaceBloc) async
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
    if(workPlaceBloc.places.isEmpty)
    {
      appHelper.showSnackBar('${workPlaceBloc.addWorkPlace} ${workPlaceBloc.first}');
      return;
    }
    int workPlaceId=await workPlaceBloc.getWorkPlaceId(workPlaceBloc.places[workPlaceBloc.placeIndex]);
   String date=dateHelper.getDate(modelBloc.dateTime);
    String strCheckDate = dateHelper.getDateInString(modelBloc.dateTime);
    int attendanceId = await modelBloc.dateFoundId(date,workPlaceId);
    // this date is registered
    if (attendanceId != -1) {
      AttendanceModel attendanceModel = await modelBloc.getAttendanceById(
          attendanceId);
      // checked in
      if (attendanceModel.checkInTime != null) {
        DateTime chDate=dateHelper.getDateTime(attendanceModel.checkInTime!);
        if(model.dateTime.hour<=chDate.hour)
        {
          appHelper.showSnackBar(workPlaceBloc.invalidTime);
          return;
        }
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
      int id = await modelBloc.dateFoundId(strDate,workPlaceId);
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
            workPlaceId:workPlaceId,
            date: date,
            checkInTime: strCheckDate,
            attendanceSymbol: 'O',

          );
          modelBloc.addAttendanceTable(afpModel);
        }
      }
      // the day befor not registered
      else
      {
        AttendanceModel afpModel = AttendanceModel
          (
          attendanceId: 1,
          workPlaceId:workPlaceId,
          date:date,
          checkInTime: strCheckDate,
          attendanceSymbol: 'O',
        );
        modelBloc.addAttendanceTable(afpModel);
      }
    }
    appHelper.showSnackBar(workPlaceBloc.register);
  }
}
class WorkTableWidget extends StatelessWidget {
   WorkTableWidget({Key? key,required this.workPlaceId,required this.workPlace,
   required this.workPlaceBloc}) : super(key: key);
   final int workPlaceId;
   final String workPlace;
   final WorkPlaceBloc workPlaceBloc;
   @override
  Widget build(BuildContext context) {
    AppHelper appHelper=AppHelper(context);
    DateHelper dateHelper=DateHelper();
    return BlocProvider(
      create: (context)=>AttendanceBloc(),
      child: BlocConsumer<AttendanceBloc,AttendanceState>(
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
              AppText(workPlaceBloc.addTable,color: Colors.teal,),
              AppSpacer(height: 30),
              Expanded(
                  flex: 2,
                  child: AppText(workPlace,color: Colors.blue,)),
              AppSpacer(),
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
                    controller:dateController, label:workPlaceBloc.dateConst, hint:''),
              ),
              AppSpacer(width: 10),
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
              AppSpacer(),
              GestureDetector(
                onTap: () async {
                   String date=dateHelper.getDate(modelBloc.dateTime);
                   int id=await modelBloc.dateFoundId(date,workPlaceId);
                     appHelper.showSnackBar('$id');
                     if(id==-1){
                       AttendanceModel attendanceModel=AttendanceModel(attendanceId:1,
                           workPlaceId:workPlaceId,
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
                  child: AppContainer(
                      color: Colors.teal,
                      child: AppText(workPlaceBloc.addButton,color: Colors.white,)))
            ],
          ),
        );
        },
      ),
    );
  }
}
class WorkPlaceWidget extends StatelessWidget {
   WorkPlaceWidget({Key? key,required this.workPlaceBloc}) : super(key: key);
   final WorkPlaceBloc workPlaceBloc;
   TextEditingController workPlaceController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 300,
      child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(workPlaceBloc.addWorkPlace),
            AppSpacer(height: 100),
            AppTextField(controller:workPlaceController, label:workPlaceBloc.workPlace, hint:workPlaceBloc.addWorkPlace),
            AppSpacer(height: 20),
            GestureDetector(
              onTap: (){
                WorkPlaceModel workPlaceModel=WorkPlaceModel(workPlaceId: 1,
                    workPlaceName: workPlaceController.text);
                workPlaceBloc.addPlace(workPlaceModel);
                Navigator.pop(context);
              },
              child: AppContainer(
                  child: AppText(workPlaceBloc.addButton)),
            )
          ],
        ),
    );
  }
}
class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({Key? key,required this.workPlaceBloc}) : super(key: key);
  final WorkPlaceBloc workPlaceBloc;
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: 200,
      height: double.infinity,
      child: Column(
        children: [
          AppSpacer(
            height: 100,
          ),
          GestureDetector(
              onTap: (){
                workPlaceBloc.changeLanguage();
              },
              child: Row(
                mainAxisAlignment: workPlaceBloc.language == 'arabic'
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  AppText(workPlaceBloc.language == 'arabic'
                      ? workPlaceBloc.appLanguage
                      : workPlaceBloc.changeLang),
                  AppSpacer(width: 10),
                  AppText(workPlaceBloc.language == 'arabic'
                      ? workPlaceBloc.changeLang
                      : workPlaceBloc.appLanguage),
                ],
              )
          )
        ],
      ),
    );
  }
}


