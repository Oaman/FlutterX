import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CollectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
      return _CollectPageState();
  }
}

class _CollectPageState extends State<CollectPage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("收藏"),

        ),
      );
  }
}