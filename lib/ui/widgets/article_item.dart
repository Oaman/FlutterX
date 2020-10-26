import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/pages/webview_page.dart';

/// Home Item
class ArticleItem extends StatelessWidget {
  final item;

  const ArticleItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      return Card(
          elevation: 3,
          child: InkWell(
            onTap: () {
              debugPrint(item['link']);
              Navigator.push(ctx, new MaterialPageRoute(builder: (context) {
                ///这里因为数据的原因，在banner中返回的是url, 在article中是link，需要转换一下格式
                item['url'] = item['link'];
                return WebViewPage(item, supportCollect: true);
              }));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(flex: 1, child: Text("作者:" + item['author'])),
                      Align(
                        alignment: Alignment.center,
                        child: Text(item['niceDate']),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: Text(
                    item['title'],
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                  child: Text(
                    item['chapterName'],
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          ));
    });
  }
}
