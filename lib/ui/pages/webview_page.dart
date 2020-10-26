import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/event/events.dart';
import 'package:flutter_app/common/http/api.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/pages/login_page.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  final data;

  final supportCollect;

  WebViewPage(this.data, {this.supportCollect = false});

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  FlutterWebviewPlugin _webViewPlugin;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _webViewPlugin = new FlutterWebviewPlugin();

    _webViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        setState(() => isLoading = false);
      } else if (state.type == WebViewState.startLoad) {
        setState(() => isLoading = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isCollect = widget.data['collect'] ?? false;
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.data['title']),
        actions: <Widget>[
          Offstage(
            offstage: !widget.supportCollect,
            child: IconButton(
                icon: Icon(Icons.favorite),
                color: isCollect ? Colors.red : Colors.white,
                ///这里不能省略 =>
                onPressed: () => _collect()),
          )
        ],
        bottom: PreferredSize(
            child: const CupertinoActivityIndicator(),
            preferredSize: const Size.fromHeight(1.0)),
        bottomOpacity: isLoading ? 1.0 : 0.0,
      ),
      url: widget.data['url'],
      withJavascript: true,
      withLocalStorage: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _webViewPlugin.dispose();
  }

  _collect() async {
    var result;
    bool isLogin = AppManager.isLogin();
    if (isLogin) {
      if (widget.data['collect']) {
        result = await Api.unCollectArticle(widget.data['id']);
      } else {
        result = await Api.collectArticle(widget.data['id']);
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
    }
    if (result['errorCode'] == 0) {
      setState(() {
        widget.data['collect'] = !widget.data['collect'];
        AppManager.eventBus
            .fire(CollectEvent(widget.data['id'], widget.data['collect']));
      });
    }
  }
}
