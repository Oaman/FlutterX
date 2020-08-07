import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPageItem extends StatefulWidget {
  final data;

  const WebViewPageItem(this.data);

  @override
  State<StatefulWidget> createState() => WebViewPageItemState();
}

class WebViewPageItemState extends State<WebViewPageItem> {
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
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.data['title']),
        bottom: PreferredSize(
            child: const CupertinoActivityIndicator(),
            preferredSize: const Size.fromHeight(1.0)),
        bottomOpacity: isLoading ? 1.0 : 0.0,
      ),
      url: widget.data['link'],
      withJavascript: true,
      withLocalStorage: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _webViewPlugin.dispose();
  }
}