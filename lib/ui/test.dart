import 'package:dio/dio.dart';

///this dart file is for test.
void main() async {
//  var dio = Dio();
//  var bannerResponse =
//      await dio.get("https://www.wanandroid.com/banner/json");
//  var bannersData = bannerResponse.data['data'];
//  print(bannersData);

  var dio = Dio();
  var articlesResponse =
  await dio.get("https://www.wanandroid.com/article/list/0/json");
  var articlesBean = articlesResponse.data['data'];
  var totalPage = articlesBean["total"];
  var articles = articlesBean['datas'];
  print(totalPage);
  print(articles);
}