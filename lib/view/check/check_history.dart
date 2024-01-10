import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_finger_print/bloc/app_states.dart';
import 'package:work_finger_print/bloc/attendance_bloc.dart';
import 'package:work_finger_print/helper/date.dart';
import 'package:work_finger_print/helper/helper_function.dart';
import '../../helper/const.dart';
import '../../model/attendance_model.dart';
import '../../widget/helper_widget.dart';
class CheckHistoryPage extends StatelessWidget {
  const CheckHistoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AttendanceBloc()..getAllAFP()..initYear(),
      child: BlocConsumer<AttendanceBloc,AppState>(
        listener: (BuildContext context, AppState state) {  },
        builder: (BuildContext context, AppState state) {
          AttendanceBloc modelBloc=AttendanceBloc.instance(context);
          modelBloc.initCheckedList();
          modelBloc.initMonthAndYear();
          //modelBloc.getAllAFP();
          return Scaffold(
            appBar: AppBar(title: const AppText('history page',fontWeight: FontWeight.normal,),
            actions: [
              IconButton(onPressed:(){
                showDialog(context: context, builder:(context){
                  return AlertDialog(
                    content: StatisticWidget(modelBloc: modelBloc,),
                  );
                });
              }, icon:Icon(Icons.insert_chart_outlined,color: Colors.purple,))
            ],
            ),
            body: CheckHistoryWidget(modelBloc:modelBloc),
          );
        },
      ),
    );
  }
}

class CheckHistoryWidget extends StatelessWidget{
  const CheckHistoryWidget({super.key,required this.modelBloc});
  final AttendanceBloc modelBloc;
  @override
  Widget build(BuildContext context) {

    TextEditingController  monthController=TextEditingController(text: '${modelBloc.month}');
    return Container(
      padding: const EdgeInsets.all(10),
      height: double.infinity,
      child: Form(
        child: Column(
          children: [
            const AppText('Attendance History ',color: Colors.teal,),
            AppSizedBox(),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AppText('month',color: Colors.blue,),
                      AppSizedBox(width: 20),
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
                          onChanged:(value){
                            modelBloc.changeMonth(value!);
                            modelBloc.getAllAFP();
                            modelBloc.checkedList.clear();
                            //modelBloc.initCheckedList();
                          }),
                    ],
                  ),
                ),
                AppSizedBox(width: 20),
                Expanded(
                  child: Row(
                    children: [
                      AppText('year',color: Colors.blue,),
                      AppSizedBox(width: 20),
                      YearsWidget(modelBloc: modelBloc),
                    ],
                  ),
                ),
              ],
            ),
            AppSizedBox(),
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
            AppSizedBox(),
            // dynamic data
             Expanded(child: HistoryWidget(modelBloc: modelBloc,))
          ],
        ),
      ),
    );
  }
}
class HistoryWidget extends StatelessWidget
{
   HistoryWidget({super.key,required this.modelBloc});
 final AttendanceBloc modelBloc;
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
          day=afpList[index].date.substring(8,10);
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
                    content: UpdateAttendanceWidget(attendanceModel: afpList[index]),
                  );
                }).then((value) {
                  modelBloc.getAllAFP();
                });
              },
              onLongPress: ()
              {
                modelBloc.deleteAFP(afpList[index].attendanceId);
                modelBloc.getAllAFP();
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
                  MakeHistoryRectangle(data: tableShift,backColor: Colors.white),
                  // attendance shift
                  MakeHistoryRectangle(data: shifts.isEmpty?newWorkShift:shifts[modelBloc.shiftIndex],backColor: Colors.white,
                    textColor:tableShift!=workShift? Colors.red:Colors.black,),
                ],
              ),
            ),
            AppSizedBox(height: 5)
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
      child: AnotherWrapableContainer(
        color: backColor,
        height: 50,
        child: AppText(data, fontWeight: fontWeight, fontSize: fontSize,color:textColor,),
      ),
    );
  }
}
class YearsWidget extends StatelessWidget {
  YearsWidget({Key? key,required this.modelBloc}) : super(key: key);
  AttendanceBloc modelBloc;
  @override
  Widget build(BuildContext context) {
   // modelBloc.initYear();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Visibility(
            visible: modelBloc.years.isEmpty?false:true,
            child: DropdownButton<int>(
                value:modelBloc.years.isEmpty?0:modelBloc.years[modelBloc.yearIndex],
                items:
                modelBloc.years.isEmpty?[
                  DropdownMenuItem<int>(
                    value:0,
                    child: AppText('register attendance first',fontSize: 10,),
                  )
                ]:modelBloc.years.map((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: AppText('$value'),
                  );
                }).toList()
                ,
                onChanged:(value){
                  modelBloc.changeYear(value!);
                  modelBloc.getAllAFP();
                  modelBloc.checkedList.clear();
                  //modelBloc.initCheckedList();
                }),
          ),
        ),
      ],
    );
  }
}
class StatisticWidget extends StatelessWidget {
  const StatisticWidget({Key? key,required this.modelBloc}) : super(key: key);
final AttendanceBloc modelBloc;
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
    return Container(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 3,
              child: AppText('attendance month statistics',fontSize: 15,color: Colors.blue,)),
          //AppSizedBox(height: 100),
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AppText('late hours:',fontSize: 15,color: Colors.blue)),
                  AppSizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('${(monthlyLateHours~/60)} hrs and ${monthlyLateHours%60} '
                          'min',fontSize: 14,),
                      AppText('($monthlyLateHours minute)',fontSize: 15,)
                    ],
                  ),
                  AppSizedBox(width: 10),
                  Visibility(
                       visible: monthlyLateHours>359?true:false,
                      child: Icon(Icons.error_outlined,color: Colors.red,))
                ],
              ),
            ),
          ),
          AppSizedBox(),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: AppText('month hours :',fontSize: 15,color: Colors.blue)),
                AppSizedBox(width: 10),
                AppText('$monthHour hrs',fontSize: 15,)
              ],
            ),
          ),
          AppSizedBox(),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: AppText('attendance hours :',fontSize: 15,color: Colors.blue)),
                AppSizedBox(width: 10),
                AppText('$attendanceHour hrs',fontSize: 15,)
              ],
            ),
          ),
          AppSizedBox(),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: AppText('vacation:',fontSize: 15,color: Colors.blue)),
                AppSizedBox(width: 10),
                AppText('$holidays days ',fontSize: 15,),
            
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class UpdateAttendanceWidget extends StatelessWidget {
   UpdateAttendanceWidget({Key? key,required this.attendanceModel}) : super(key: key);
  final AttendanceModel attendanceModel;
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
      child: BlocConsumer<AttendanceBloc,AppState>(
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
                AppSizedBox(height: 20),
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
                AppSizedBox(),
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
                AppSizedBox(),
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
                AppSizedBox(width: 10),
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
                AppSizedBox(),
                // shift symbols
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText('shift',color: Colors.teal,),
                    AppSizedBox(width: 20),
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
                AppSizedBox(),
                GestureDetector(
                    onTap: (){
                      String? strCheckIn;
                      String? strCheckOut;
                      if(attendanceModel.checkInTime!=null)
                      {
                        strCheckIn=dateHelper.getDateInString(modelBloc.checkInDate);
                      }
                      if(attendanceModel.checkOutTime!=null)
                      {
                        strCheckOut=dateHelper.getDateInString(modelBloc.checkOutDate);
                      }
                      AttendanceModel updatedAttendanceModel=AttendanceModel(
                         attendanceId:1, month:modelBloc.dateTime.month,
                         date:dateHelper.getDate(modelBloc.dateTime),
                         attendanceSymbol:symbols[modelBloc.symbolIndex],
                        checkInTime: strCheckIn,
                        checkOutTime: strCheckOut
                     );
                     modelBloc.updateAttendanceTable(attendanceModel.attendanceId, updatedAttendanceModel);
                     Navigator.pop(context);
                    },
                    child: WrapableContainer(child: AppText('update',color: Colors.white,)
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


