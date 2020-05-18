
import 'package:flutter/material.dart';
import 'package:githubclientapp/constant/constants.dart';
import 'package:githubclientapp/http/api.dart';
import 'package:githubclientapp/http/http_util_with_cookie.dart';
import 'package:githubclientapp/widgets/article_item.dart';
import 'package:githubclientapp/widgets/end_line.dart';
import 'package:githubclientapp/widgets/slide_view.dart';

class HomeListPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomeListPageState();
  }

}

class HomeListPageState extends State<HomeListPage>{
  ScrollController _controller = new ScrollController();
  List listData = new List();
  var curPage = 0;
  SlideView _bannerView;
  var listTotalSize = 0;

  HomeListPageState(){
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels =_controller.position.pixels;
      if (maxScroll == pixels && listData.length < listTotalSize) {
        getHomeArticleList();
      }
    });
  }


  @override
  void initState() {
    super.initState();
    getBanner();
    getHomeArticleList();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Null> _pullToRefresh() async {
    curPage = 0;
    getBanner();
    getHomeArticleList();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(listData == null){
      return Center(
        child: new CircularProgressIndicator(),
      );
    }else{
      Widget listView = ListView.builder(
          itemCount: listData.length + 1,
          itemBuilder: (context, i) => buildItem(i),
          controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  Widget buildItem(int i){
    if(i == 0){
      return Container(
        height: 180.0,
        child: _bannerView,
      );
    }

    i -= 1;
    var itemData = listData[i];
    if(itemData is String && itemData == Constants.END_LINE_TAG){
      return EndLine();
    }
    return ArticleItem(itemData);
  }

  void getBanner(){
    HttpUtil.get(Api.BANNER, (data){
      if(data != null){
        setState(() {
          _bannerView = SlideView(data);
        });
      }
    });
  }

  void getHomeArticleList(){
    String url = Api.ARTICLE_LIST + "$curPage/json";
    HttpUtil.get(url, (data){
      if (data != null) {
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
}