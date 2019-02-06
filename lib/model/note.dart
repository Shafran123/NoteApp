class Note{

    int _id;
    String _title;
    String _description;
    String _date;
    int _piority;

    Note(this._title, this._date, this._piority,[this._description]);

    Note.withId(this._id, this._title, this._date, this._piority,[this._description]);
    
    int get id => _id;
    String get title => _title;
    String get description => _description;
    int get priority => _piority;
    String get date => _date;

    set title(String newtitle){
      if(newtitle.length <= 255){
        this._title = newtitle;
      }
    }

    set description(String newdesc){
      if(newdesc.length <= 1000){
        this._description= newdesc;
      }
    }

    set priority(int newpi){
      if(newpi >=1 && newpi < 2){
        this._piority=newpi;
      }
    }

  set date(String newDate){
    this._date=newDate;
  }

  //Convert a note object to into a map
  Map<String,dynamic> toMap(){
    var map = Map<String, dynamic>();
  if(id != null){
    map['id'] = _id;
  }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _piority;
    map['date'] = _date;
    return map;
  }

  //Extract
  Note.formMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._piority  = map['priority'];
    this._date = map['date'];
  }
}