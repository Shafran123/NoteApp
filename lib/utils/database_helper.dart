import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notes/model/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singletom
  static Database _database;

  String noteTable = 'noteTable';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper =
          DatabaseHelper._createInstance(); // only excute once singleton object
    }
    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    //Get directory
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    //create
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,'
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //Fetch Operation
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    // var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');

    var result = await db.query(noteTable, orderBy: '$colPriority ASC');

    return result;
  }

  //Insert
  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //update
  Future<int> updateNote(Note note) async {
    var db = await this.database;

    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //delete
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId  = $id');
    return result; 
  }

  //number of obj

  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get map list and convert in to notelist
  Future<List<Note>> getNoteList() async{

    var noteMapList = await getNoteMapList(); //get maplist database
    int count = noteMapList.length; //count the number of map entiers

    List<Note> noteList = List<Note>();

    //loop

    for (int i =0 ; i < count; i++){
      noteList.add(Note.formMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
