
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_finger_print/helper/const.dart';
import 'package:work_finger_print/helper/lang_const/arabic_const.dart';
import 'package:work_finger_print/helper/lang_const/english_const.dart';
import '../../business_layer/states/workPlace_state.dart';
import '../../database/workPlace_operation.dart';
import '../../model/workPlace_model.dart';
class WorkPlaceBloc extends Cubit<WorkPlaceState>
{
  WorkPlaceBloc():super(InitWorkPlaceState());
  WorkPlaceOperation workPlaceOperation=WorkPlaceOperation();
  static WorkPlaceBloc instance(BuildContext context)=>BlocProvider.of(context);
  List<String> places=[];
  int placeIndex=0;
  String place='';
  String language='';
  // String _homePage='';
   // String _registerButton='';
   // String _addWorkPlace='';
   // String _addButton='';
   // String _workPlace='';
   // String _dateConstEn='';
   // String _timeConstEn='';
   // String _addTableEn='';
   // String _fromEn='';
   // String _toEn='';
   // String _checkInEn='';
   // String _checkOutEn='';
   // String _workHourEn='';
   // String _shiftSymbolEn='';
   // String _attendanceSymbolEn='';
   // String _updateAttendanceEn='';
   // String _updateEn='';
   // String _monthStatisticsEn='';
   // String _lateHourEn='';
   // String _monthHourEn='';
   // String _attendanceHourEn='';
   // String _vacationEn='';
/////////////////////////////////////////////////////////////////
  String get appLanguage=> language=='arabic'?appLanguageAr:appLanguageEn;
  String get andConst=> language=='arabic'?andConstAr:andConstEn;
  String get about=> language=='arabic'?aboutAr:aboutEn;
  String get first=> language=='arabic'?firstAr:firstEn;
  String get changeLang=> language=='arabic'?changeLanguageAr:changeLanguageEn;
  String get invalidTime=> language=='arabic'?invalidTimeAr:invalidTimeEn;
  String get invalidDate=> language=='arabic'?invalidDateAr:invalidDateEn;
  String get homePage=> language=='arabic'?homePageAr:homePageEn;
  String get historyPage=> language=='arabic'?historyPageAr:historyPageEn;
  String get registerButton=> language=='arabic'?registerButtonAr:registerButtonEn;
  String get register=> language=='arabic'?registerAr:registerEn;
  String get noDataRegistered=> language=='arabic'?noDataRegisteredAr:noDataRegisteredEn;
  String get addWorkPlace=> language=='arabic'?addWorkPlaceAr:addWorkPlaceEn;
  String get addButton=> language=='arabic'?addButtonAr:addButtonEn;
  String get workPlace=> language=='arabic'?workPlaceAr:workPlaceEn;
  String get dateConst=> language=='arabic'?dateConstAr:dateConstEn;
  String get timeConst=> language=='arabic'?timeConstAr:timeConstEn;
  String get hourConst=> language=='arabic'?hourConstAr:hourConstEn;
  String get minuteConst=> language=='arabic'?minuteConstAr:minuteConstEn;
  String get dayConst=> language=='arabic'?dayConstAr:dayConstEn;
  String get addTable=> language=='arabic'?addTableAr:addTableEn;
  String get from=> language=='arabic'?fromAr:fromEn;
  String get to=> language=='arabic'?toAr:toEn;
  String get checkIn=> language=='arabic'?checkInAr:checkInEn;
  String get checkOut=> language=='arabic'?checkOutAr:checkOutEn;
  String get workHour=> language=='arabic'?workHourAr:workHourEn;
  String get shiftSymbol=> language=='arabic'?shiftSymbolAr:shiftSymbolEn;
  String get attendanceSymbol=> language=='arabic'?attendanceSymbolAr:attendanceSymbolEn;
  String get updateAttendance=> language=='arabic'?updateAttendanceAr:updateAttendanceEn;
  String get update=> language=='arabic'?updateAr:updateEn;
  String get monthStatistics=> language=='arabic'?monthStatisticsAr:monthStatisticsEn;
  String get lateHour=> language=='arabic'?lateHourAr:lateHourEn;
  String get monthHour=> language=='arabic'?monthHourAr:monthHourEn;
  String get attendanceHour=> language=='arabic'?attendanceHourAr:attendanceHourEn;
  String get vacation=> language=='arabic'?vacationAr:vacationEn;

  getLanguage()async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
     language=preferences.getString(appLanguageKey)??'arabic';
  }
  changeLanguage()async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(language=='arabic')
    preferences.setString(appLanguageKey,'english');
    else
      preferences.setString(appLanguageKey,'arabic');
    getLanguage();
    emit(ChangeLanguage());
  }
  changePlace(String workPlace)
  {
    place=workPlace;
    emit(ChangeWorkPlace());
  }
  changePlaceIndex(String value)
  {
    placeIndex=places.indexOf(value);
    emit(ChangeWorkPlaceIndex());
  }
  addPlace(WorkPlaceModel workPlaceModel)
  {
    workPlaceOperation.insert(workPlaceModel);
    emit(AddingWorkPlace());
  }
  Future<int> getWorkPlaceId(String place)async
  {
    int id=await workPlaceOperation.getId(place);
    return id;
  }
  getWorkPlaces()async
  {
    places=await workPlaceOperation.getWorkPlacesNames();
    emit(GetAllPlaces());
  }
}