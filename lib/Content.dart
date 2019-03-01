import 'package:flutter/material.dart';
import 'package:flutter_diary/DatabaseHelper.dart';
import 'package:flutter_diary/homeScreen.dart';

class Content extends StatefulWidget {
  @override
  ContentState createState() => new ContentState();
}

class ContentState extends State<Content> {
  String title = "";
  String content = "";

  TextEditingController editingController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Your content"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                content = content + editingController.text;
                title = title + titleController.text;

                if (title.length > 1 && content.length > 1) {
                  DiaryModel model = new DiaryModel(title, content, "time");
                  DatabaseHelper.get().insertOrReplace(model);

                  Navigator.of(context).pop(true);
                }
              });
            },
          )
        ],
      ),
      body: new Container(
        padding: const EdgeInsets.all(10.0),
        child: new Center(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(
                  labelText: "Title",
                  hintText: "Enter title here",
                ),
                maxLines: 1,
                maxLength: 70,
                controller: titleController,
              ),
              new TextField(
                decoration: new InputDecoration(
                    labelText: "Content", hintText: "Share your mind"),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: editingController,
              ),
              new Text("Hello" + "$content")
            ],
          ),
        ),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  void saveValueInDatabase(String title, String content) {}
}

class MenuItem {
  const MenuItem(this.title, this.icon);

  final String title;
  final IconData icon;
}

const List<MenuItem> menuItems = const <MenuItem>[
  const MenuItem("Save", Icons.check)
];
