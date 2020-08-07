import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// Home Item
class HomeItem extends StatelessWidget {
  final item;

  const HomeItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
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
            margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
            child: Text(
              item['chapterName'],
              style: TextStyle(color: Theme.of(context).primaryColor),
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }
}
