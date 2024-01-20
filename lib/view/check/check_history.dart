import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_finger_print/business_layer/bloc/workPlace_bloc.dart';
import 'package:work_finger_print/business_layer/states/workPlace_state.dart';
import 'package:work_finger_print/helper/date.dart';
import 'package:work_finger_print/helper/helper_function.dart';
import '../../business_layer/bloc/attendance_bloc.dart';
import '../../business_layer/states/attendance_states.dart';
import '../../helper/const.dart';
import '../../model/attendance_model.dart';
import '../../widget/helper_widget.dart';
class CheckHistoryPage extends StatelessWidget {
   CheckHistoryPage({Key? key,required this.workPlace,required this.workPlaceId}) : super(key: key);
  String workPlace;
  int workPlaceId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(mainContext)=>WorkPlaceBloc()..getWorkPlaces()..changePlace(workPlace),
      child: BlocConsumer<WorkPlaceBloc,WorkPlaceState>(
        listener: (mainContext,mainState){},
        builder:(mainContext,mainState){
          WorkPlaceBloc workPlaceBloc=WorkPlaceBloc.instance(mainContext);
          workPlaceBloc.changePlaceIndex(workPlaceBloc.place);
          return BlocProvider(
          create: (BuildContext context)=>AttendanceBloc()..initFromDate()..initToDate()
            ..getAllAttendanceBetweenDates(workPlaceId),
          child: BlocConsumer<AttendanceBloc,AttendanceState>(
            listener: (BuildContext context, AttendanceState state) {  },
            builder: (BuildContext context, AttendanceState state) {
              AttendanceBloc modelBloc=AttendanceBloc.instance(context);
              //modelBloc.getAllAttendanceBetweenDates(workPlaceId);
               modelBloc.initCheckedList();
              // modelBloc.initMonthAndYear();
              //modelBloc.getAllAFP();
              return Scaffold(
                appBar: AppBar(title: const AppText('history page',fontWeight: FontWeight.normal,),
                actions: [
                  IconButton(onPressed:(){
                    showDialog(context: context, builder:(context){
                      return AlertDialog(
                        content: StatisticWidget(modelBloc: modelBloc,workPlaceBloc: workPlaceBloc,),
                      );
                    });
                  }, icon:Icon(Icons.insert_chart_outlined,color: Colors.purple,))
                ],
                ),
                body: CheckHistoryWidget(modelBloc:modelBloc,workPlaceBloc: workPlaceBloc),
              );
            },
          ),
        );
        },
      ),
    );
  }
}
class CheckHistoryWidget extends StatelessWidget{
  const CheckHistoryWidget({super.key,required this.workPlaceBloc,required this.modelBloc});
  final WorkPlaceBloc workPlaceBloc;
  final AttendanceBloc modelBloc;
  @override
  Widget build(BuildContext context) {
    List<String> places=workPlaceBloc.places;
    AppHelper appHelper=AppHelper(context);
    //TextEditingController  monthController=TextEditingController(text: '${modelBloc.month}');
    return Container(
      padding: const EdgeInsets.all(10),
      height: double.infinity,
      child: Form(
        child: Column(
          children: [
            const AppText('Attendance History ',color: Colors.teal,),
            AppSpacer(),
            places.isEmpty?AppSpacer():Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                    value: places[workPlaceBloc.placeIndex],
                    items: places.map((e){
                      return DropdownMenuItem(
                      value: e,
                      child: AppText(e));
                }).toList(), onChanged:(value)async{
                      workPlaceBloc.changePlace(value!);
                      workPlaceBloc.changePlaceIndex(value);
            int workPlaceId=await workPlaceBloc.getWorkPlaceId(places[workPlaceBloc.placeIndex]);
            modelBloc.getAllAttendanceBetweenDates(workPlaceId);
                })
              ],
            ),
            AppSpacer(),
            Visibility(
              visible:true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText('from',fontSize: 15,),
                  AppSpacer(width:5,),
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: AppButton(
                        onTap: ()async{
                          DateTime? fromDate=await appHelper.showDate();
                          if(fromDate!=null)
                          {
                            if(fromDate.isAfter(modelBloc.toDate))
                            {
                              appHelper.showSnackBar('invalid selected date');
                              return;
                            }
                            modelBloc.changeFromDate(fromDate);
                            int workPlaceId=await workPlaceBloc.getWorkPlaceId(places[workPlaceBloc.placeIndex]);
                            modelBloc.getAllAttendanceBetweenDates(workPlaceId);
                          }
                        },
                        data:modelBloc.strFromDate,backGroundColor: Colors.white,textColor: Colors.black54,
                      ),
                    ),
                  ),
                  AppSpacer(width: 10),
                  AppText('to',fontSize: 15,),
                  AppSpacer(width:5,),
                  Expanded(child: Card(
                      elevation: 10,
                      child: AppButton(
                        onTap: ()async{
                          DateTime? toDate=await appHelper.showDate();
                          if(toDate!=null)
                          {
                            if(toDate.isBefore(modelBloc.fromDate))
                            {
                              appHelper.showSnackBar('invalid selected date');
                              return;
                            }
                            modelBloc.changeToDate(toDate);
                            int workPlaceId=await workPlaceBloc.getWorkPlaceId(places[workPlaceBloc.placeIndex]);
                            modelBloc.getAllAttendanceBetweenDates(workPlaceId);
                          }
                        },
                        data:modelBloc.strToDate,backGroundColor: Colors.white,textColor: Colors.black54,))),

                ],
              ),
            ),
            AppSpacer(height: 20,),
            Row(
             children: [
               Checkbox(value: false, onChanged:(value){}),
              MakeHistoryRectangle(data: 'date',textColor: Colors.white,fontSize: 12,),
              MakeHistoryRectangle(data:'check in',textColor: Colors.white,fontSize: 12),
              MakeHistoryRectangle(data:'check out',textColor: Colors.white,fontSize: 11),
               MakeHistoryRectangle(data: 'work hours',textColor: Colors.white,fontSize:10,),
               MakeHistoryRectangle(data:'table shift',textColor: Colors.white,fontSize: 12),
               MakeHistoryRectangle(data:'work shift',textColor: Colors.white,fontSize: 12),

             ],
           ),
            AppSpacer(),
            // dynamic data
             Expanded(child: HistoryWidget(modelBloc: modelBloc,workPlaceBloc: workPlaceBloc,))
          ],
        ),
      ),
    );
  }
}
class HistoryWidget extends StatelessWidget
{
   HistoryWidget({super.key,required this.modelBloc,required this.workPlaceBloc});
 final AttendanceBloc modelBloc;
 final WorkPlaceBloc workPlaceBloc;
 DateHelper dateHelper=DateHelper();
  @override
  Widget build(BuildContext context) {
    List<AttendanceModel> afpList=modelBloc.afpList;
    return afpList.isEmpty?AppText('no data registered'):ListView.builder(
      itemBuilder: (context,index){
        String day='',checkIn='',checkOut='',tableShift='',workShift='',newWorkShift='',
        firstShift='',secondShift='';
        int wHrs=0;
        int minuteLated=0;
        String? strCheckInDate=afpList[index].checkInTime;
        String? strCheckOutDate=afpList[index].checkOutTime;
        List<String> shifts=[];
        //DateTime? checkInDate=DateTime.parse(strCheckInDate!);
        if(afpList.isNotEmpty)
        {
          wHrs=strCheckOutDate!=null?modelBloc.getWorkingHours(DateTime.parse(strCheckInDate!),DateTime.parse(strCheckOutDate)):0;
          DateTime checkDate=dateHelper.getDateTime(afpList[index].date);
          day='${checkDate.day}-${checkDate.month}';
          checkIn=strCheckInDate!=null?dateHelper.getTimeOfDay(DateTime.parse(afpList[index].checkInTime!)):'0:0';
          checkOut=strCheckOutDate!=null?dateHelper.getTimeOfDay(DateTime.parse(afpList[index].checkOutTime!)):'0:0';
          String strMinuteLated=checkIn.length>4?checkIn.substring(3):checkIn.substring(2);
           minuteLated=int.parse(strMinuteLated);
          tableShift=afpList[index].attendanceSymbol;
         // workShift=strCheckOutDate!=null?modelBloc.getShift(DateTime.parse(strCheckInDate!),DateTime.parse(strCheckOutDate),
           //   tableSymbol:tableShift):'O';
          newWorkShift=strCheckOutDate!=null?modelBloc.getShiftFromList(DateTime.parse(strCheckInDate!),DateTime.parse(strCheckOutDate)):'';
          if(newWorkShift.contains('||')) {
            firstShift = newWorkShift.substring(0, newWorkShift.indexOf('||'));
            secondShift = newWorkShift.substring(newWorkShift.indexOf('||') + 2);
            shifts.add(firstShift);
            shifts.add(secondShift);
          }
        }
        return  Column(
          children: [
            GestureDetector(
              onTap: (){
                modelBloc.changeShiftIndex();
              //   String firstShift='',secondShift='';
              //   newWorkShift=strCheckOutDate!=null?modelBloc.getShiftFromList(DateTime.parse(strCheckInDate!),DateTime.parse(strCheckOutDate)):'';
              // if(newWorkShift.contains('||'))
              // {
              //    firstShift=newWorkShift.substring(0,newWorkShift.indexOf('||'));
              //    secondShift=newWorkShift.substring(newWorkShift.indexOf('||')+2);
              // }
              //   AppHelper(context).showSnackBar(shifts.toString());
              },
              onDoubleTap: (){
                showDialog(context: context, builder:(context){
                  return AlertDialog(
                    content: UpdateAttendanceWidget(attendanceModel: afpList[index],workPlaceBloc: workPlaceBloc,),
                  );
                }).then((value)async {
                  int workPlaceId=await workPlaceBloc.getWorkPlaceId(workPlaceBloc.places[workPlaceBloc.placeIndex]);
                  modelBloc.getAllAttendanceBetweenDates(workPlaceId);
                });
              },
              onLongPress:()async
              {
                modelBloc.deleteAFP(afpList[index].attendanceId);
                int workPlaceId=await workPlaceBloc.getWorkPlaceId(workPlaceBloc.places[workPlaceBloc.placeIndex]);
                modelBloc.getAllAttendanceBetweenDates(workPlaceId);
              },
              child: Row(
                children: [
                  Checkbox(value:modelBloc.checkedList[index], onChanged:(value){
                    modelBloc.changeChecked(index,value!);
                  }),
                  //date
                 MakeHistoryRectangle(data:day,
                   fontWeight: FontWeight.bold,backColor: Colors.white,),
                  // check in
                  MakeHistoryRectangle(data: checkIn,
                      fontWeight: FontWeight.bold,backColor: Colors.white,
                  textColor: minuteLated>30?Colors.red:Colors.black,
                  ),
                  // check out
                  MakeHistoryRectangle(data: checkOut,
                      fontWeight: FontWeight.bold,backColor: Colors.white,),
                  // working hours
                  MakeHistoryRectangle(data: '$wHrs',backColor: Colors.white),
                  // table shift
                  MakeHistoryRectangle(data: tableShift,backColor: Colors.white,fontSize: 14,),
                  // attendance shift
                  MakeHistoryRectangle(data: shifts.isEmpty?newWorkShift:shifts[modelBloc.shiftIndex],backColor: Colors.white,
                    textColor:tableShift!=workShift? Colors.red:Colors.black,),
                ],
              ),
            ),
            AppSpacer(height: 5)
          ],
        );
      },
      itemCount:afpList.length,);
  }

}
class  MakeHistoryRectangle extends StatelessWidget {
  const MakeHistoryRectangle(
      {super.key, required this.data, this.fontSize = 15, this.fontWeight = FontWeight
          .bold,this.textColor=Colors.black,this.backColor=Colors.blueAccent});
  final String data;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color backColor;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppContainer(
        borderColor: Colors.black,
        color: backColor,
        height: 50,
        child: AppText(data, fontWeight: fontWeight, fontSize: fontSize,color:textColor,),
      ),
    );
  }
}

class StatisticWidget extends StatelessWidget {
  const StatisticWidget({Key? key,required this.modelBloc,required this.workPlaceBloc}) : super(key: key);
final AttendanceBloc modelBloc;
final WorkPlaceBloc workPlaceBloc;
@override
  Widget build(BuildContext context) {
    List<AttendanceModel> attendanceModelList=modelBloc.afpList;
    List<bool> checkedList=modelBloc.checkedList;
    List<AttendanceModel> editAttendanceList=[];
    attendanceModelList.forEach((element) {
      editAttendanceList.add(element);
    });
    for(int i=0;i<checkedList.length;i++)
    {
      if(checkedList[i])
      {
        editAttendanceList.remove(attendanceModelList[i]);
      }
    }
    int monthHour=modelBloc.getMonthHour(attendanceModelList);
    int attendanceHour=modelBloc.totalWorkingHour(attendanceModelList);
    int monthlyLateHours=modelBloc.getMonthlyLateHours(editAttendanceList);
    int holidays=modelBloc.numberOfHolidays(monthHour, attendanceHour);
    int hoursDiff=monthHour>attendanceHour?monthHour-attendanceHour:0;
    return Container(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText('attendance month statistics',fontSize: 15,color: Colors.blue,),
          //AppSizedBox(height: 100),
          AppSpacer(height: 30),
          Expanded(
            flex:1,
            child: AppContainer(

                width: 200,
                child: AppText(workPlaceBloc.place,color: Colors.blue,fontSize: 20,)),
          ),
          AppSpacer(height: 50),
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AppText('late hours:',fontSize: 15,color: Colors.blue)),
                  AppSpacer(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('${(monthlyLateHours~/60)} hrs and ${monthlyLateHours%60} '
                          'min',fontSize: 14,),
                      AppText('($monthlyLateHours minute)',fontSize: 15,)
                    ],
                  ),
                  AppSpacer(width: 10),
                  Visibility(
                       visible: monthlyLateHours>359?true:false,
                      child: Icon(Icons.error_outlined,color: Colors.red,))
                ],
              ),
            ),
          ),
          AppSpacer(),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: AppText('month hours :',fontSize: 15,color: Colors.blue)),
                AppSpacer(width: 10),
                AppText('$monthHour hrs',fontSize: 15,)
              ],
            ),
          ),
          AppSpacer(),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: AppText('attendance hours :',fontSize: 15,color: Colors.blue)),
                AppSpacer(width: 10),
                AppText('$attendanceHour hrs',fontSize: 15,)
              ],
            ),
          ),
          AppSpacer(),
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AppText('vacation:',fontSize: 15,color: Colors.blue)),
                  AppSpacer(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText('$holidays days ',fontSize: 15,),
                      AppText('( for $hoursDiff hours )',fontSize: 15,)
                    ],
                  ),

                ],
              ),
            ),
          ),
          AppSpacer(),

        ],
      ),
    );
  }
}
class UpdateAttendanceWidget extends StatelessWidget {
   UpdateAttendanceWidget({Key? key,required this.attendanceModel,required this.workPlaceBloc}) : super(key: key);
  final AttendanceModel attendanceModel;
  final WorkPlaceBloc workPlaceBloc;
  DateHelper dateHelper=DateHelper();
  @override
  Widget build(BuildContext context) {
    AppHelper appHelper=AppHelper(context);
    String? date=attendanceModel.date;
    String? strCheckInDate=attendanceModel.checkInTime;
    String? strCheckOutDate=attendanceModel.checkOutTime;
//appHelper.showSnackBar(date!);
    //print(date);
    // String? strCheckInDate=attendanceModel.checkInTime!=null?attendanceModel.checkInTime:'';
    // String? strCheckOutDate=attendanceModel.checkOutTime!=null?attendanceModel.checkOutTime:'';
     String shiftSymbol=attendanceModel.attendanceSymbol;
    return BlocProvider(
      create:(context)=>AttendanceBloc()..changeDate(dateHelper.getDateTime(date))
      ..initCheckInDate(attendanceModel)..initCheckOutDate(attendanceModel)..initIndex(attendanceModel),
      child: BlocConsumer<AttendanceBloc,AttendanceState>(
        listener: (context,state){},
        builder:(context,state) {
          AttendanceBloc modelBloc=AttendanceBloc.instance(context);
          TextEditingController dateController=TextEditingController(text:dateHelper.getDate(modelBloc.dateTime));
          TextEditingController checkInController=TextEditingController(text: dateHelper.getTimeOfDay(modelBloc.checkInDate));
          TextEditingController checkOutDateController=TextEditingController(text:dateHelper.getDate(modelBloc.checkOutDate));
          TextEditingController checkOutController=TextEditingController(text: dateHelper.getTimeOfDay(modelBloc.checkOutDate));
          TextEditingController shiftSymbolController=TextEditingController(text: shiftSymbol);
          return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: 500,
            child: Column(
              children: [
                AppText('update your attendance',color: Colors.teal,),
                AppSpacer(height: 20),
                //date
                AppTextField(
                    onTap: ()async{
                      DateTime? chooseDate=await appHelper.showDate();
                      if(chooseDate!=null)
                      {
                        modelBloc.changeDate(chooseDate);
                      }
                    },
                    controller:dateController, label:'date', hint:''),
                AppSpacer(),
                //check in
                Visibility(
                  visible: attendanceModel.checkInTime!=null?true:false,
                  child: AppTextField(
                      onTap: ()async{
                       TimeOfDay? timeOfDay=await  appHelper.showTime();
                       if(timeOfDay!=null)
                        {
                          DateTime checkInDate=dateHelper.getDateTimeByHour(modelBloc.checkInDate,timeOfDay.hour,timeOfDay.minute);
                         modelBloc.changeCheckInDate(checkInDate,timeSelected: true);
                       }
                      },
                      controller:checkInController, label:'check in', hint:''),
                ),
                AppSpacer(),
                //check out
                Visibility(
                  visible: attendanceModel.checkOutTime!=null?true:false,
                  child: AppTextField(
                      onTap: ()async{
                        TimeOfDay? timeOfDay=await  appHelper.showTime();
                        if(timeOfDay!=null)
                        {
                          int hour=timeOfDay.hour;
                          int minute=timeOfDay.minute;
                          DateTime checkOutDate=dateHelper.getDateTimeByHour(modelBloc.checkOutDate, hour, minute);
                          modelBloc.changeCheckOutDate(checkOutDate,timeSelected: true);
                        }
                      },
                      controller:checkOutController, label:'check out', hint:''),
                ),
                AppSpacer(width: 10),
                // checkout date
                Visibility(
                  visible: attendanceModel.checkOutTime!=null?true:false,
                  child: AppTextField(
                      onTap: ()async{
                        DateTime? newCheckOutDate=await  appHelper.showDate();
                        if(newCheckOutDate!=null)
                        {
                         modelBloc.changeCheckOutDate(newCheckOutDate);
                        }
                      },
                      controller:checkOutDateController, label:'check out date', hint:''),
                ),
                AppSpacer(),
                // shift symbols
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText('shift',color: Colors.teal,),
                    AppSpacer(width: 20),
                    DropdownButton<String>(
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
                  ],
                ),
                AppSpacer(),
                GestureDetector(
                    onTap: ()async{
                      String? strCheckIn;
                      String? strCheckOut;
                      int workPlaceId=await workPlaceBloc.getWorkPlaceId(workPlaceBloc.places[
                        workPlaceBloc.placeIndex
                      ]);
                      if(attendanceModel.checkInTime!=null)
                      {
                        strCheckIn=dateHelper.getDateInString(modelBloc.checkInDate);
                      }
                      if(attendanceModel.checkOutTime!=null)
                      {
                        strCheckOut=dateHelper.getDateInString(modelBloc.checkOutDate);
                      }
                      AttendanceModel updatedAttendanceModel=AttendanceModel(
                         attendanceId:1,workPlaceId:workPlaceId,
                         date:dateHelper.getDate(modelBloc.dateTime),
                         attendanceSymbol:symbols[modelBloc.symbolIndex],
                        checkInTime: strCheckIn,
                        checkOutTime: strCheckOut
                     );
                     modelBloc.updateAttendanceTable(attendanceModel.attendanceId, updatedAttendanceModel);
                     Navigator.pop(context);
                    },
                    child: AppContainer(child: AppText('update',color: Colors.white,)
                    ,color: Colors.teal))
              ],
            ),
          ),
        );
        },
      ),
    );
  }
}
// class YearsWidget extends StatelessWidget {
//   YearsWidget({Key? key,required this.modelBloc,required this.workPlaceBloc}) : super(key: key);
//   final AttendanceBloc modelBloc;
//   final WorkPlaceBloc workPlaceBloc;
//   @override
//   Widget build(BuildContext context) {
//    // modelBloc.initYear();
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           child: Visibility(
//             visible: modelBloc.years.isEmpty?false:true,
//             child: DropdownButton<int>(
//                 value:modelBloc.years.isEmpty?0:modelBloc.years[modelBloc.yearIndex],
//                 items:
//                 modelBloc.years.isEmpty?[
//                   DropdownMenuItem<int>(
//                     value:0,
//                     child: AppText('register attendance first',fontSize: 10,),
//                   )
//                 ]:modelBloc.years.map((value) {
//                   return DropdownMenuItem<int>(
//                     value: value,
//                     child: AppText('$value'),
//                   );
//                 }).toList()
//                 ,
//                 onChanged:(value)async{
//                   modelBloc.changeYear(value!);
//                   int workPlaceId=await workPlaceBloc.getWorkPlaceId(workPlaceBloc.places[workPlaceBloc.placeIndex]);
//                   modelBloc.getAllAFP(workPlaceId);
//                   modelBloc.checkedList.clear();
//                   //modelBloc.initCheckedList();
//                 }),
//           ),
//         ),
//       ],
//     );
//   }
// }
/*
* Visibility(
              visible:!modelBloc.showDate,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        AppText('month',color: Colors.blue,),
                        AppSpacer(width: 20),
                        DropdownButton<int>(
                            elevation: 0,
                            value:months[modelBloc.monthIndex],
                            items:
                            months.map((value){
                              return DropdownMenuItem(
                                  value: value,
                                  child: AppText('$value'));
                            }).toList()
                            ,
                            onChanged:(value)async{
                              modelBloc.changeMonth(value!);
                              int workPlaceId=await workPlaceBloc.getWorkPlaceId(places[workPlaceBloc.placeIndex]);
                              modelBloc.getAllAFP(workPlaceId);
                              modelBloc.checkedList.clear();
                              //modelBloc.initCheckedList();
                            }),
                      ],
                    ),
                  ),
                  AppSpacer(width: 20),
                  Expanded(
                    child: Row(
                      children: [
                        AppText('year',color: Colors.blue,),
                        AppSpacer(width: 20),
                        YearsWidget(modelBloc: modelBloc,workPlaceBloc: workPlaceBloc,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacer(),
* */

