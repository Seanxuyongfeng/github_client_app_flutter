
import 'package:flutter/material.dart';
import 'package:githubclientapp/constant/constants.dart';
import 'package:githubclientapp/http/api.dart';
import 'package:githubclientapp/http/http_util_with_cookie.dart';
import 'package:githubclientapp/pages/login_page.dart';
import 'package:githubclientapp/util/DataUtils.dart';
import 'package:githubclientapp/widgets/end_line.dart';

import 'article_detail_page.dart';

class MyFavoritePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('喜欢的文章'),
      ),
      body: MyFavoriteListPage(),
    );
  }


}

class MyFavoriteListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyFavoriteListPageState();
  }

}

class MyFavoriteListPageState extends State<MyFavoriteListPage>{
  List listData = List();
  int curPage = 0;
  ScrollController _controller = ScrollController();
  int listTotalSize = 0;

  @override
  void initState() {
    super.initState();
    _getFavoriteList();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels && listData.length < listTotalSize) {
        _getFavoriteList();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Null> _pullToRefresh() async {
    curPage = 0;
    _getFavoriteList();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(listData == null || listData.isEmpty){
      return Center(
        child: CircularProgressIndicator(),
      );
    }else{
      Widget listView = ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: listData.length,
        itemBuilder: (context, i) => _buildItem(i),
        controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  void _getFavoriteList(){
    String url = Api.COLLECT_LIST + "$curPage/json";
    HttpUtil.get(url, (data){
      if(data != null){
        Map<String, dynamic> map = data;

        var _listData = map['datas'];

        listTotalSize = map["total"];

        setState(() {
          List list1 = List();
          if (curPage == 0) {
            listData.clear();
          }
          curPage++;

          list1.addAll(listData);
          list1.addAll(_listData);
          if (list1.length >= listTotalSize) {
            list1.add(Constants.END_LINE_TAG);
          }
          listData = list1;
        });
      }
    });
  }


  Widget _buildItem(int i){
    var itemData = listData[i];
    if(i == listData.length - 1 &&
        itemData.toString() == Constants.END_LINE_TAG){
      return EndLine();
    }

    Row authorRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Text('作者: '),
              Text(
                itemData['author'],
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
        Text(itemData['niceDate']),
      ],
    );

    Row titleRow = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            itemData['title'],
            softWrap: true,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );


    Row chapterName = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          child: Icon(
            Icons.favorite, color: Colors.red,
          ),
          onTap: (){
            _handleItemCancleFavorite(itemData);
          },
        )
      ],
    );


    Column column = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: authorRow,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: titleRow,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: chapterName,
        ),
      ],
    );

    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: (){
          _itemClick(itemData);
        },
        child: column,
      ),
    );
  }

  void _handleItemCancleFavorite(itemData){
    DataUtils.isLogin().then((isLogin) {
      if (!isLogin) {
        // 未登录
        _login();
      } else {
        _itemUnFavorite(itemData);
      }
    });
  }

  void _login(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return LoginPage();
    }));
  }

  void _itemClick(var itemData){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return ArticleDetailPage(title: itemData['title'], url: itemData['link']);
    }));
  }

  void _itemUnFavorite(var itemData){
    String url = Api.UNCOLLECT_LIST;
    Map<String, String> map = Map();
    map['originId'] = itemData['originId'].toString();
    url = url + itemData['id'].toString() + "/json";
    HttpUtil.post(url, (data) {
      setState(() {
        listData.remove(itemData);
      });
    }, params: map);
  }
}