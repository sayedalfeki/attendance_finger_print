
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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