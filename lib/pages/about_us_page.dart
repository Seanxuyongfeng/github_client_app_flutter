import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new AboutUsPageeState();
  }

}

class AboutUsPageeState extends State<AboutUsPage>{
  @override
  Widget build(BuildContext context) {
    Widget icon = Image.asset(
      'images/ic_launcher_round.png',
      width: 100.0,
      height: 100.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
        children: <Widget>[
          icon,
        ],
      ),
    );
  }
  
}