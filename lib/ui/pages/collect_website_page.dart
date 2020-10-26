import 'package:flutter/material.dart';
import 'package:flutter_app/common/http/api.dart';
import 'package:flutter_app/ui/pages/collect_add_website_page.dart';
import 'package:toast/toast.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WebsiteCollectPage extends StatefulWidget {
  @override
  _WebsiteCollectPageState createState() => _WebsiteCollectPageState();
}

class _WebsiteCollectPageState extends State<WebsiteCollectPage>
    with AutomaticKeepAliveClientMixin {
  bool _isHidden = false;

  //收藏列表
  List _collects = [];

  @override
  void initState() {
    super.initState();
    _getCollects();
  }

  _getCollects() async {
    var result = await Api.getWebSiteCollects();
    if (result != null) {
      var data = result['data'];
      _collects.clear();
      _collects.addAll(data);
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
              onRefresh: () => _getCollects(),
              child: ListView.separated(
                physics:AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(22.0),
                  itemBuilder: (context, i) => _buildItem(context, i),
                  separatorBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Divider(color: Colors.grey),
                    );
                  },
                  itemCount: _collects.length),
            )),

        /// 定位
        Positioned(
          bottom: 18.0,
          right: 18.0,
          //悬浮按钮
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _addCollect,
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  _buildItem(BuildContext context, int i) {
    var item = _collects[i];
    ///侧滑删除
    return Slidable(
        ///控制action显示的方式
        delegate:  SlidableDrawerDelegate(),
        ///右侧的action
        secondaryActions: <Widget>[
          new IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => _delCollect(item),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item['name'], style: TextStyle(fontSize: 22.0)),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                item['link'],
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ));
  }

  _addCollect() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => WebsiteAddPage()));
    if (result != null) {
      _collects.add(result);
    }
  }

  _delCollect(item) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    var result = await Api.unCollectWebsite(item['id']);
    Navigator.pop(context);

    if (result['errorCode'] != 0) {
      Toast.show(result['errorMsg'], context, gravity: Toast.CENTER);
    } else {
      setState(() {
        _collects.remove(item);
      });
    }
  }
}
