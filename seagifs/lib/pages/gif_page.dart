import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"],
          style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
          ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share,color: Colors.white,),            
            onPressed: (){
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}