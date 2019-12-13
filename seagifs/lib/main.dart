import 'package:flutter/material.dart';
import 'package:seagifs/pages/home_page.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      hintColor: Colors.white,             
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(50.0)
          )
      ),
    ),
    
  ));
}