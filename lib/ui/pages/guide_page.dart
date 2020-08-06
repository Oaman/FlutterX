import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/utils.dart';
import 'package:flutter_app/ui/pages/main_page.dart';

class GuidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GuidePageState();
  }
}

class GuidePageState extends State<GuidePage> {
  List<String> _guideImgPaths = [
    Utils.getPath("guide1"),
    Utils.getPath("guide2"),
    Utils.getPath("guide3"),
    Utils.getPath("guide4")
  ];

  List<Widget> _guideWidgets = List();

  @override
  void initState() {
    super.initState();
    initGuideWidget();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Swiper(
            autoStart: false,
            circular: false,
            indicator: RectangleSwiperIndicator(
                padding: EdgeInsets.only(bottom: 30.0),
                itemActiveColor: Colors.red,
                itemColor: Colors.blue),
            children: _guideWidgets);
      }),
    );
  }

  void initGuideWidget() {
    for (int i = 0; i < _guideImgPaths.length; i++) {
      if (i == _guideImgPaths.length - 1) {
        _guideWidgets.add(new Stack(
          children: <Widget>[
            Image.asset(
              _guideImgPaths[i],
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            new Align(
              alignment: Alignment.bottomCenter,
              child: new Container(
                margin: EdgeInsets.only(bottom: 160.0),
                child: new Ink(
                  color: Colors.blue,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) {
                        return MainPage();
                      }));
                    },
                    child: new CircleAvatar(
                      radius: 48.0,
                      child: new Text(
                        '立即体验',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
      } else {
        _guideWidgets.add(Image.asset(
          _guideImgPaths[i],
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ));
      }
    }
  }
}
