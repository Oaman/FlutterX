import 'package:banner_view/banner_view.dart';
import 'package:dio/dio.dart';

// import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/http/api.dart';
import 'package:flutter_app/ui/pages/webview_page_banner.dart';
import 'package:flutter_app/ui/widgets/home_item.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class City {
  final String name;

  const City(this.name);

  City.fromJson(Map<String, dynamic> json) : name = json["name"];

  Map<String, dynamic> toJson() => {"name": name};
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

  bool showGoBack = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var bottomPixels = _scrollController.position.pixels;
      if (maxScroll == bottomPixels && _articlesList.length < totalPage) {
        _getArticlesList();
      }
      if (bottomPixels < 1000 && showGoBack) {
        setState(() => showGoBack = false);
      } else if (bottomPixels >= 1000 && !showGoBack) {
        setState(() => showGoBack = true);
      }
    });
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    // SpUtil.putString("key", "value123");
    // var string = SpUtil.getString("key");
    // print(string);
    // debugPrint(string);
    //
    // var city = City("beijing");
    // SpUtil.putObject("city", city);
    // City obj = SpUtil.getObj("city", (v) => City.fromJson(v));
    // print(obj.name);
    //
    // var city2 = City("shanghai");
    // List cities = [city, city2];
    // SpUtil.putObjectList("cities", cities);
    // List<City> list = SpUtil.getObjList("cities", (v) => City.fromJson(v));
    // print("===list ${list.toString()}");
    // for (var c in list) {
    //   print("===${c.name}");
    // }
    //
    // var nowDateMs = DateUtil.getNowDateMs();
    // print(nowDateMs);
    //
    // var formatDateMs = DateUtil.formatDateMs(nowDateMs,
    //     format: DateFormats.full); //2019-07-09 16:16:16
    // print(formatDateMs);
    //
    // var decodeBase64 = EncryptUtil.encodeBase64("this is the data");
    // print(decodeBase64);
    //
    // var data = EncryptUtil.decodeBase64(decodeBase64);
    // print(data);
    //
    // var encodeMd5 = EncryptUtil.encodeMd5("this is data for md5");
    // print(encodeMd5);
    //
    // String objStr = "{\"name\":\"成都市\"}";
    // City obj2 = JsonUtil.getObj(objStr, (v) => City.fromJson(v));
    // print(obj2.name);
    //
    // var empty = ObjectUtil.isEmpty(null);
    // print(empty);

    return Scaffold(
      body: new Stack(
        children: <Widget>[
          Offstage(
            offstage: !isLoading,
            child: Center(
              child: CircularProgressIndicator(),
            ),
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
      ),
      floatingActionButton: !showGoBack
          ? null
          : FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0.0,
                    duration: Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn);
              },
              child: Icon(Icons.arrow_upward),
            ),
    );
  }

  Future<void> _getBannerList() async {
    var bannerResponse = await Api.getBanner();
    var bannersData = bannerResponse['data'];
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
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return WebViewPageBanner(bannerData);
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
