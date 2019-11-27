import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=9871f7e1";

Color colorBackground = Color(0xffFCFBED);
Color colorAppBar = Color(0xff8cbf3f);
Color colorText = Color(0xff595959);

void main() async{ 
  runApp(MaterialApp(    
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
      hintColor: colorText,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorText),
            borderRadius: BorderRadius.circular(50.0)
          )
      ),
      primaryColor: colorAppBar,
    ),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController =TextEditingController();
  final dolarController =TextEditingController();
  final euroController =TextEditingController();

  double dolar;
  double euro;

  String _textAppBar = "Carregando...";

  void _cleanAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text){
    if (text.isEmpty) {
      _cleanAll();
      return;      
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  
  void _dolarChanged(String text){
    if (text.isEmpty) {
      _cleanAll();
      return;      
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }
  
  void _euroChanged(String text){
    if (text.isEmpty) {
      _cleanAll();
      return;      
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro /dolar).toStringAsFixed(2);
  }

  @override
       void initState() {
       super.initState();
       setState(() {
         _textAppBar = "\$ Conversor \$";
         //_textAppBar = "Carregando...";
       });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,      
      appBar: AppBar(        
        centerTitle: true,        
        title: Text(
          _textAppBar,          
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0            
          ),
        ),        
        backgroundColor: colorAppBar,
      ),      
      body: FutureBuilder<Map>(
        future: getData(),        
        builder: (context, snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Image.asset(
                    "images/money.gif",
                    height: 10000.0,
                    width: 500.0,
                  )
              ) ;   
              break;
            default:              
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar Dados :(",
                    style: TextStyle(
                      color: colorAppBar,
                      fontSize: 25.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }else{   
                               
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(                  
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[                      
                      Icon(Icons.monetization_on, size: 150.0, color: colorAppBar),
                      buildTextField("Reais","R\$: ", realController, _realChanged),
                      Divider(),
                      buildTextField("Dolar","US\$: ", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euro","€: ", euroController, _euroChanged),                                           
                    ],
                  )
                );
              }
          }
        },
      ) 
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function function){
  return TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: c,
            onChanged: function,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: colorText,                
              ),
              border: OutlineInputBorder(),
              prefixText: prefix
            ),            
            style: TextStyle(
              color: colorText,
              fontSize: 25.0
            )
        );
}

