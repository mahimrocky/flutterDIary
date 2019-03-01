import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_diary/homeScreen.dart';

void main() {
  runApp(new MaterialApp(
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/HomeScreen': (BuildContext context) => new HomeScreen()
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, gotoHome);
  }

  void gotoHome() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    //startTime();

    animationController =
        new AnimationController(vsync: this, duration: new Duration(seconds: 2))
          ..addStatusListener((status) {

            if(status==AnimationStatus.completed){
              gotoHome();
            }
          });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new AnimatedBuilder(
            animation: animationController,
            child: new Container(
              child: new Image.asset("images/launcher.png"),
            ),
            builder: (BuildContext context, Widget widget) {
              return new Transform.rotate(
                angle: animationController.value * 6.3,
                child: widget,
              );
            }),
      ),
    );
  }
}
