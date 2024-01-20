import 'package:flutter/material.dart';
import 'view/check/check_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CheckPage(),
  ));
}


