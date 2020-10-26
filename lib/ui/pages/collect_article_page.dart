import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/event/events.dart';
import 'package:flutter_app/common/http/api.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/widgets/article_item.dart';

class ArticleCollectPage extends StatefulWidget {
  @override
  _ArticleCollectPageState createState() => _ArticleCollectPageState();
}

class _ArticleCollectPageState extends State<ArticleCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHidden = false;

  ///滑动控制器
  ScrollController _controller = new ScrollController();

  //收藏列表
  List _collects = [];
  var curPage = 0;

  var pageCount;

  StreamSubscription<CollectEvent> collectEventListen;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ///获得 SrollController 监听控件可以滚动的最大范围
      var maxScroll = _controller.position.maxScrollExtent;

      ///获得当前位置的像素值
      var pixels = _controller.position.pixels;

      ///当前滑动位置到达底部，同时还有更多数据
      if (maxScroll == pixels && curPage < pageCount) {
        ///加载更多
        _getCollects();
      }
    });
    collectEventListen = AppManager.eventBus.on<CollectEvent>().listen((event) {
      ///页面没有被dispose
      if (mounted) {
        //取消收藏
        if (!event.collect) {
          _collects.removeWhere((item) {
            return item['id'] == event.id;
          });
        }
      }
    });
    _getCollects();
  }

  @override
  void dispose() {
    collectEventListen?.cancel();
    _controller.dispose();
    super.dispose();
  }

  _getCollects([bool refresh = false]) async {
    if (refresh) {
      curPage = 0;
    }
    var result = await Api.getArticleCollects(curPage);
    print("获取收藏列表结果：$result");
    if (result != null) {
      if (curPage == 0) {
        _collects.clear();
      }
      curPage++;
      var data = result['data'];
      pageCount = data['pageCount'];
      _collects.addAll(data['datas']);
      _isHidden = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _isHidden,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        Offstage(
          ///不为空就隐藏
          offstage: _collects.isNotEmpty || !_isHidden,
          child: Center(
            child: Text("(＞﹏＜) 你还没有收藏任何内容......"),
          ),
        ),
        Offstage(
          //為空就隱藏
          offstage: _collects.isEmpty,
          child: RefreshIndicator(
              onRefresh: () => _getCollects(true),
              child: ListView.builder(
                //总是能滑动，因为数据少，listview无法滑动，
                //RefreshIndicator 就无法更新
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _collects.length,
                itemBuilder: (context, i) => _buildItem(i),
                controller: _controller,
              )),
        )
      ],
    );
  }

  /// tab切换不重置
  @override
  bool get wantKeepAlive => true;

  _buildItem(int i) {
    //只收藏站内
    _collects[i]['id'] = _collects[i]['originId'];
    _collects[i]['collect'] = true;
    return ArticleItem(_collects[i]);
  }
}
