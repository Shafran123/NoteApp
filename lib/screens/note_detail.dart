import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notes/model/note.dart';
import 'package:notes/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';


class NoteDetail extends StatefulWidget {

  
 final String appbarTitle;
 final Note note;

  NoteDetail(this.note,this.appbarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appbarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _level = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  String appbarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  NoteDetailState(this.note, this.appbarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle txtstyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descController.text =   note.description;

    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
    child: Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            moveToLastScreen();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10),
        child: ListView(
          children: <Widget>[
            //First Ele
            ListTile(
              title: DropdownButton(
                items: _level.map((String dropdownitem) {
                  return DropdownMenuItem<String>(
                      value: dropdownitem, child: Text(dropdownitem));
                }).toList(),
                style: txtstyle,
                value: getPriorityAsString(note.priority),
                onChanged: (userval) {
                  setState(() {
                    debugPrint('user selectes $userval');
                    updatePriorityAsInt(userval);
                  });
                },
              ),
            ),
            //Second Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: txtstyle,
                onChanged: (value) {
                  debugPrint('lol');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: txtstyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              ),
            ),
            //Third Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descController,
                style: txtstyle,
                onChanged: (value) {
                  debugPrint('lol2');
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Decription',
                    labelStyle: txtstyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0))),
              ),
            ),
            //Fourth element
            Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint('hi');
                            _save();
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint('DEL');
                            _delete();
                          });
                        },
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    ));
  }

  void moveToLastScreen(){
    Navigator.pop(context , true);
  }

  //convert  the piority
  void updatePriorityAsInt(String value){
    switch (value){
      case 'High':
        note.priority=1;
        break;
      case 'Low':
        note.priority =2;
        break;
    }
  }

  String getPriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority  = _level[0];
        break;
      case 2:
        priority = _level[1];
        break;
    }
    return priority; 
  }

  void updateTitle(){
    note.title = titleController.text;
  }

  void updateDescription(){
    note.description =descController.text;
  }

  void _save() async{

    moveToLastScreen();
    note.date  = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null){
     result =  await helper.updateNote(note);
    }else{
      result = await helper.insertNote(note);
    }

    if(result != 0 ){
      _showAlertDialog('Status', 'Note Saved');
    }else{
      _showAlertDialog('Status', 'Problem');
    }
  }

  void _delete() async {

    moveToLastScreen();

    if(note.id == null){
      _showAlertDialog('Stauts', 'No note delete');
      return;

    }

    int result =  await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted');

    }else{
      _showAlertDialog('Status', 'Error');
    }

  }


  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}
