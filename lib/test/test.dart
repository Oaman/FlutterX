import 'package:dio/dio.dart';

///this dart file is for test.
void main() async {
  // var dio = Dio();
  // var bannerResponse =
  //     await dio.get("https://www.wanandroid.com/banner/json");
  // var bannersData = bannerResponse.data['data'];
  // print(bannersData);

  // print("finish");
  // var articlesResponse =
  // await dio.get("https://www.wanandroid.com/article/list/0/json");
  // var articlesBean = articlesResponse.data['data'];
  // var totalPage = articlesBean["total"];
  // var articles = articlesBean['datas'];
  // print(totalPage);
  // print(articles);
  // getBanner();

  var data = await getBanner3();
  print(data.data['data']);
  print("finish");
}

/// don't have return result
void getBanner() async {
  var response = await Dio().get("https://www.wanandroid.com/banner/json",
      onReceiveProgress: (count, total) {
    print("count:$count total:$total");
  });
  print(response.data['data']);
}

///have return result
Future<Response> getBanner2() async {
  var response = await Dio().get("https://www.wanandroid.com/banner/json");
  // print(response.data['data']);
  return response;
}

///have return result use Dio().request()
Future<Response> getBanner3() async {
  var dio = Dio();
  dio.interceptors.add(new InterceptorsWrapper(onRequest: (options) {
    print(options.baseUrl + "--" + options.path);
  }, onResponse: (response) {
    print(response.data['data']);
  }));
  var response = await dio.request("https://www.wanandroid.com/banner/json");
  // print(response.data['data']);
  return response;
}
