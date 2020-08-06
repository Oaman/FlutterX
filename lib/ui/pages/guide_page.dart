import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/utils.dart';

class GuidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GuidePageState();
  }
}

class GuidePageState extends State<GuidePage> {
  static List<String> guideImgPaths = [
    Utils.getPath("guide1"),
    Utils.getPath("guide2"),
    Utils.getPath("guide3"),
    Utils.getPath("guide4")
  ];

  static List<Widget> guideWidgets = guideImgPaths.map((path) {
    return Image.asset(
      path,
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Swiper(autoStart:false,
        circular: false,
        indicator: CircleSwiperIndicator(
          radius: 4,
        ),
        children: guideWidgets);
  }
}
