import 'package:flutter/material.dart';
import 'package:flutter_app/common/event/events.dart';
import 'package:flutter_app/common/http/api.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/pages/collect_page.dart';
import 'package:flutter_app/ui/pages/login_page.dart';

class DrawerItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawerItemState();
  }
}

class DrawerItemState extends State<DrawerItem> {
  String _userName;

  @override
  void initState() {
    super.initState();
    AppManager.eventBus.on<LoginEvent>().listen((event) {
      _userName = event.userName;

      AppManager.prefs.setString(AppManager.ACCOUNT, _userName);
      if (mounted) {
        setState(() {});
      }
    });
    _userName = AppManager.prefs.getString(AppManager.ACCOUNT);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        ///使得statusBar颜色一致
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: InkWell(
                ///点击这里去登录，如果登录了就什么也不做
                onTap: () => _itemClick(null),
                child: Column(
                  children: <Widget>[
                    ///善用Padding效果
                    Padding(
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                      child: CircleAvatar(
                        radius: 30,
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                    Text(
                      _userName ?? "请先登录",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
              )),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("我的收藏"),
            onTap: () {
              ///点击这里去收藏，如果没有登录就先去登录
              _itemClick(CollectPage());
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("我的收藏"),
            onTap: () {
              ///点击这里去收藏，如果没有登录就先去登录
              _itemClick(CollectPage());
            },
          ),
          Offstage(
            /// true就是不显示  false就显示
            offstage: _userName == null,
            child: InkWell(
              onTap: () {
                setState(() {
                  AppManager.prefs.setString(AppManager.ACCOUNT, null);
                  Api.clearCookie();
                  _userName = null;
                  AppManager.eventBus.fire(LogoutEvent());
                });
              },
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("退出登录"),
              ),
            ),
          )
        ],
      ),
    );
  }

  _itemClick(Widget page) {
    var desPage = _userName == null ? LoginPage() : page;
    if (desPage != null) {
      Navigator.push(context, new MaterialPageRoute(builder: (_) {
        return desPage;
      }));
    }
  }
}
