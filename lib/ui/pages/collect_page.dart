import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/res/icons.dart';
import 'package:flutter_app/ui/pages/page_collect_article.dart';

class CollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectPageState();
  }
}

class _CollectPageState extends State<CollectPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("收藏"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(article),
                ),
                Tab(
                  icon: Icon(website),
                )
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[
            ArticleCollectPage(),
            ArticleCollectPage(),
          ],),
        ));
  }
}
