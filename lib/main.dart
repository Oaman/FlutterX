import 'package:flutter/material.dart';
import 'package:flutter_app/ui/pages/guide_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: GuidePage()
    );
  }
}
