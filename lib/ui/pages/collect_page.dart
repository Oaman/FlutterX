import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/res/icons.dart';
import 'package:flutter_app/ui/pages/collect_article_page.dart';
import 'package:flutter_app/ui/pages/collect_website_page.dart';

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
            WebsiteCollectPage(),
          ],),
        ));
  }
}
