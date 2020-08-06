import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Search"),
        ),
        body: Center(
          child: Text("Search Page"),
        ),
      ),
    );
  }
}
