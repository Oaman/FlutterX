import 'package:banner_view/banner_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/pages/webview_page.dart';
import 'package:flutter_app/ui/widgets/home_item.dart';
import '';
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<HomePage> {
  /// steps:
  ///   1 get banners and articles data.
  ///   2 layout
  ///   3 refresh data logic
  ///   4 WebView page

  ///control the scroll when at bottom
  ScrollController _scrollController = ScrollController();

  ///articles lit
  List _articlesList = [];

  ///banners list
  List _bannersList = [];

  ///we need set curPage = 0, or, it will have issue(because curPage is null default in fultter)
  int curPage = 0;

  int totalPage = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var bottomPixels = _scrollController.position.pixels;
      if (maxScroll == bottomPixels && _articlesList.length < totalPage) {
        _getArticlesList();
      }
    });
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        Offstage(
          offstage: !isLoading,
          child: CircularProgressIndicator(),
        ),
        Offstage(
          ///isLoading is for content
          offstage: isLoading,
          child: RefreshIndicator(
              child: ListView.builder(
                ///Note: itemCount itemBuilder controller should be show here.
                itemCount: _articlesList.length + 1,
                itemBuilder: (context, i) => buildItem(i),
                controller: _scrollController,
              ),
              onRefresh: _refreshData),
        )
      ],
    );
  }

  Future<void> _getBannerList() async {
    var dio = Dio();
    var bannerResponse =
        await dio.get("https://www.wanandroid.com/banner/json");
    var bannersData = bannerResponse.data['data'];
    _bannersList.clear();
    _bannersList = bannersData;
    setState(() {});
  }

  Future<void> _getArticlesList() async {
    var dio = Dio();
    var articlesResponse =
        await dio.get("https://www.wanandroid.com/article/list/$curPage/json");
    var articlesBean = articlesResponse.data['data'];
    if (curPage == 0) {
      _articlesList.clear();
    }
    totalPage = articlesBean["total"];
    var articles = articlesBean['datas'];
    _articlesList.addAll(articles);
    curPage++;
    debugPrint("scroll to page $curPage");
    setState(() {});
  }

  ///TODO need to solve reload issue
  Future<void> _refreshData() async {
    var banners = _getBannerList();
    var articles = _getArticlesList();
    await Future.wait([banners, articles]);
    isLoading = false;
    setState(() {});
  }

  Widget buildItem(int i) {
    if (i == 0) {
      return new Container(
        height: 220,
        child: _bannerView(),
      );
    } else {
      return HomeItem(_articlesList[i - 1]);
    }
  }

  Widget _bannerView() {
    var bannerWidgets = _bannersList.map((bannerData) {
      return InkWell(
        child: Image.network(
          bannerData['imagePath'],
          fit: BoxFit.fill,
        ),
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context){
              return WebViewPage(bannerData);
          }));
        },
      );
    }).toList();
    return bannerWidgets.isEmpty
        ? null
        : BannerView(
            bannerWidgets,
            intervalDuration: const Duration(seconds: 2),
          );
  }
}
