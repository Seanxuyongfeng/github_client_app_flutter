import 'package:flutter/material.dart';
import 'package:githubclientapp/constant/colors.dart';

class WanAndroidApp extends StatefulWidget{
  @override
  _WanAndroidAppState createState() {
    // TODO: implement createState
    return new _WanAndroidAppState();
  }
}

class _WanAndroidAppState extends State<WanAndroidApp>{
  var appBarTitles = ['首页', '发现', '我的'];
  int _tabIndex = 0;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
          primaryColor: AppColors.colorPrimary, accentColor: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitles[_tabIndex],
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.search),
              onPressed: (){

              },
            ),
          ],
        ),
        bottomNavigationBar: new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(appBarTitles[0]), backgroundColor: Colors.blue),
            BottomNavigationBarItem(icon: Icon(Icons.widgets), title: Text(appBarTitles[1]), backgroundColor: Colors.blue),
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text(appBarTitles[2]), backgroundColor: Colors.blue),
          ],
          currentIndex: _tabIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (int index){
            setState(() {
              _tabIndex = index;
            });
          },
        ),
      ),
    );
  }

}
