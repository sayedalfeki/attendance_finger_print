const String appName='بصمة';
const String databaseName='attendance';
const String attendanceTableName='attendance_finger_print';
const String workPlaceTableName='work_place';
const String attendanceIdColumn='attendance_id';
const String attendanceDateColumn='attendance_date';
const String attendanceSymbolColumn='attendance_symbol';
const String monthColumn='attendance_month';
const String checkInColumn='attendance_check_in';
const String checkOutColumn='attendance_check_out';
const String workPlaceIdColumn='work_place_id';
const String workPlaceNameColumn='work_place_name';
const String workingHours='working_hours';
const String shift='shift';
List<int> months=[1,2,3,4,5,6,7,8,9,10,11,12];
List shiftSymbols=['M1','M3','M5','M6','A1','A3','A6','M2','M4','A2','A4','X1','X2','X3','L1','L2','L4','N1','N2','L1N1','L2N2',
  'A1N1','A3N2','O'];
List attendanceHours=[6,6,6,6,6,6,6,7,7,7,7,9,9,9,12,12,12,12,12,24,24,18,18,0];
List<String> symbols=['M1','M2','M3','M4','M5','M6','A1','A2','A3','A4','A6','X1','X2','X3','L1','L2',
  'L4','L1N1','L2N2','A1N1','A3N2','N1','N2','O'];
List list6=[];
List list7=['','','','','','','','','','','','(M5)-2','(M5)-1||(M6)-2','M5||(M6)-1','(X3)-2||M6','(X3)-1',
'X3','(L4)-2','(L4)-1','L4',''];
List list8=['','','','','','','(L1N1)-2','(L1N1)-1','L1N1','','','','(M1)-2','(M1)-1||(M2)-2','M1||(M2)-1'
  ,'M2||(X1)-2','(X1)-1','X1','(L1)-2','(L1)-1','L1'];
List list9=['','','','','','','','(L2N2)-2','(L2N2)-1','L2N2','','','','(M3)-2','(M3)-1||(M4)-2',
'M3||(M4)-1','M4||(X2)-2','(X2)-1','X2','(L2)-2','(L2)-1','L2'];
List list10=['','','','','','','','','(L1N1)-2','(L2N2)-1','','','','','(M1)-2','(M2)-2||(M3)-1',
'(M4)-1','(X1)-2','(X2)-1','(X2)-1','(L1)-2','(L2)-1','',''];
List list11=['','','','','','','','','','(L2N2)-2','','','','','','(M3)-2','(M4)-2','','(X2)-2||A6',
'','','(L2)-2'];
List list12=['','','','','','','(A1N1)-2','(A1N1)-1','A1N1','','','','','','','','','','A6','A6||(A4)-1',
'A4','A2',''];
List list13=['','','','','','','(A1N1)-2','(A1N1)-1','A1N1','A1N1','','','','','','','','','(A6)-1','(A6)-1'
,'A4','A4',''];
List list14=['','','','','','','(A1N1)-2','(A1N1)-1','A1N1','A1N1','','','','','','','','','(A1)-2'
,'(A1)-1','A1','A2',''];
List list15=['','','','','','','','(A3N2)-2','(A3N2)-1','A3N2','','','','','','','','','','(A3)-2',
'(A3)-1','A3','',''];
List list16=['','','','','','','','','(A1N1)-2','(A3N2)-1','','','','','','','','','','','','(A1)-2'];
List list17=['','','','','','','','','','(A3N2)-2','','','','','','','','','','','','(A3)-2'];
List list18=['','','','','','','','','','','','','','','','','','','','',''];
List list19=['','','','','','','','','','','','','','','','',''];
List list20=['','','','','','','(N1)-2','(N1)-1','N1','','','','','','','','','','','','',''];
List list21=['','','','','','','','(N2)-2','(N2)-1','N2','','','','','','','','','','','',''];
List list22=['','','','','','','','','(N1)-2','(N2)-1','','','','','','','','','','','',''];
List list23=['','','','','','','','','','(N2)-2','','','','','','','','','','','',''];

List allShifts=[[],[],[],[],[],[],list6,list7,list8,list9,list10,list11,list12,list13,list14
,list15,list16,list17,list18,list19,list20,list21,list22,list23];

