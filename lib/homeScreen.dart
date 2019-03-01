import 'package:flutter/material.dart';
import 'package:flutter_diary/Content.dart';
import 'package:flutter_diary/DatabaseHelper.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

List<DiaryModel> diaryList = new List();

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("My Flutter Diary"),
      ),
      body: new Center(
        child: new ListView.builder(
          itemCount: diaryList.length,
          itemBuilder: (context, index) => new CustomItem(diaryList[index]),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: gotoContentPage,
        child: new Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  void gotoContentPage() {
    Navigator
        .push(this.context,
            MaterialPageRoute(builder: (context) => new Content()))
        .then((val) {
      refresh();
    });
  }

  /*
  * Init state. call when page newly open
  * */
  @override
  void initState() {
    super.initState();

    DatabaseHelper.get().getAllContent().then((models) {
      setState(() {
        diaryList = models;
      });
    });
  }

  /*
 * For refresh page when page open from back stack
 * */

  void refresh() {
    DatabaseHelper.get().getAllContent().then((models) {
      setState(() {
        diaryList = models;
      });
    });
  }

  /*
  *  Call when  any change in this class
  * */

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }
}

/*
* Class of List item. It holds the custom item. And perform all listener and value setting.
*
* */

class CustomItem extends StatefulWidget {
  final DiaryModel model;

  CustomItem(this.model);

  @override
  CustomItemState createState() => new CustomItemState(model);
}

class CustomItemState extends State<CustomItem> {
  final DiaryModel model;

  CustomItemState(this.model);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        final snackBar = SnackBar(content: Text("${model.id}"));
        Scaffold.of(context).showSnackBar(snackBar);
      },
      onLongPress: () {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                content: new FlatButton(
                  onPressed: () => performDelete(model, context),
                  child: new Text("Delete"),
                ),
              );
            }).then((val){
              new HomeScreenState().refresh();
        });
      },
      behavior: HitTestBehavior.opaque,
      child: new Container(
        height: 50.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: titleSection(context, model.title, model.content),
      ),
    );
  }

  /*
  * Card widget where we distribute data and design
  * */

  Widget titleSection(BuildContext context, String title, String content) {
    return new GestureDetector(
      child: new Container(
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new Text(title),
                  ),
                  new Text(
                    content,
                  )
                ],
              ),
            ),
            new Text(
              "time",
              style: new TextStyle(
                color: Colors.grey[500],
                fontSize: 10.0,
              ),
            )
          ],
        ),
        decoration: new BoxDecoration(
          border: new Border(
            bottom: new BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  performDelete(DiaryModel model, BuildContext context) {
    int r = 0;
    DatabaseHelper.get().deleteItem(model.id).then((result) {
      setState(() {
        final snackBar = SnackBar(content: Text("Delte succefully"));
        Scaffold.of(context).showSnackBar(snackBar);
      });
    });

    Navigator.of(context).pop(true);


  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
}

/*
*  Diary model
* */

class DiaryModel {
  String title;
  String content;
  String time;
  int id;

  DiaryModel(this.title, this.content, this.time);
}

/*
* Dummy list. but not need now
* */

List<DiaryModel> diaryModels = <DiaryModel>[
  DiaryModel("title 1", "Content 1", "Time 1"),
  DiaryModel("title 2", "Content 2", "Time 2"),
  DiaryModel("title 3", "Content 3", "Time 3"),
];
