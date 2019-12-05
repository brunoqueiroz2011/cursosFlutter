import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
 
  final _toDoController =TextEditingController();

  List _toDoList = [];

  bool _isEdit = false;
  int _todoEditPos;

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState(){
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDO(){
    setState(() {     
      if (!_isEdit) { 
        Map<String, dynamic> newToDo = Map();
        newToDo["title"] =_toDoController.text;
        _toDoController.text = "";               
        newToDo["ok"] = false;
        _toDoList.add(newToDo);

        _saveData();
      } else {
        _toDoList[_todoEditPos]["title"] = _toDoController.text;
        _toDoController.text = "";
        _isEdit = false;        
        _saveData();
      }      
    });
  }

  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a,b){
        if (a["ok"] && !b["ok"]) return 1;
        else if(!a["ok"] && b["ok"]) return -1;
        else return 0;        
      });
      _saveData();
    });
    return null;
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent)
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDO,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: buildItem,
              ),              
            ),
          )
        ],
      ),
      
    );
  }

  Widget _slideRightBackground(){
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white
            ),
            Text(
              " Editar",
              style:TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.left,
            )
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _slideLeftBackground(){
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,              
            ),
            Text(
              " Deletar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget buildItem(BuildContext context, int index){
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: _slideRightBackground(),
      secondaryBackground: _slideLeftBackground(),
      //direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ?
          Icons.check : Icons.error),),
        onChanged: (c){
          setState(() {
            _toDoList[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction){
        if (direction ==DismissDirection.endToStart) {
          setState(() {
            _lastRemoved = Map.from(_toDoList[index]);
            _lastRemovedPos = index;
            _toDoList.removeAt(index);

            _saveData();

            final snack = SnackBar(
              content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
              action: SnackBarAction(label: "Desfazer",
                  onPressed: () {
                    setState(() {
                      _toDoList.insert(_lastRemovedPos, _lastRemoved);
                      _saveData();
                    });
                  }),
              duration: Duration(seconds: 2),
            );

            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(snack);

          }); 
        }else{
          setState(() {  
            _todoEditPos = index;
            _isEdit =true;
            _toDoController.text =  _toDoList[index]["title"];
          });
        }        
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }  

  Future<String> _readData() async{
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

}