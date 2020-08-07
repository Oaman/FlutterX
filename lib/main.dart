import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ui/pages/dash_page.dart';
import 'package:flutter_app/ui/pages/guide_page.dart';
import 'package:flutter_app/ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: DashPage());
  }
}
