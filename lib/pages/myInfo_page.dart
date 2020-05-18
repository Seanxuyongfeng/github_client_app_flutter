
import 'package:flutter/material.dart';
import 'package:githubclientapp/constant/constants.dart';
import 'package:githubclientapp/event/login_event.dart';
import 'package:githubclientapp/pages/about_us_page.dart';
import 'package:githubclientapp/pages/login_page.dart';
import 'package:githubclientapp/util/DataUtils.dart';

import 'my_favorite_article.dart';

class MyInfoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyInfoPageState();
  }

}

class MyInfoPageState extends State<MyInfoPage>{
  String userName;


  @override
  void initState() {
    super.initState();
    _getName();
    Constants.eventBus.on<LoginEvent>().listen((event) {
      _getName();
    });
  }

  void _getName() async{
    DataUtils.getUserName().then((username){
      setState(() {
        userName = username;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
        'images/ic_launcher_round.png',
      width: 100.0,
      height: 100.0
    );
    Widget raisedButton = new RaisedButton(
      child: Text(
        userName == null? "请登录" : userName,
        style: TextStyle(color: Colors.white),
      ),
      color: Theme.of(context).accentColor,
      onPressed: () async {
        await DataUtils.isLogin().then((isLogin){
          if(!isLogin){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return LoginPage();
            }));
          }else{
            print("Already login");
          }
        });
      },
    );
    Widget listLike = new ListTile(
      leading: const Icon(Icons.favorite),
      title: const Text("喜欢的文章"),
      trailing:
        Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
      onTap: () async{
        await DataUtils.isLogin().then((isLogin){
          if(isLogin){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return MyFavoritePage();
            }));
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          }
        });
        print('您点击了  喜欢的文章');
      },
    );

    Widget listAboutUs = new ListTile(
      leading: const Icon(Icons.info),
      title: const Text('关于我们'),
      trailing:
        Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return AboutUsPage();
        }));
      },
    );

    Widget listLogout = new ListTile(
      leading: const Icon(Icons.info),
      title: const Text('退出登录'),
      trailing:
        Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
      onTap: () async{
        setState(() {
          DataUtils.clearLoginInfo();
          userName = null;
        });
      },
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      children: <Widget>[
        image,
        raisedButton,
        listLike,
        listAboutUs,
        listLogout
      ],
    );
  }
}