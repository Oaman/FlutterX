import 'package:flutter/material.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/pages/home_page.dart';
import 'package:flutter_app/ui/pages/search_page.dart';
import 'package:flutter_app/ui/widgets/drawer_item.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  var _selectionIndex = 0;

  static const TextStyle _style =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _contentPages = <Widget>[
    HomePage(),
    Text("Email Page", style: _style),
    Text("Phone Page", style: _style),
  ];

  initData() async {
    Iterable<Future> futures = [
      AppManager.initApp(),
      Future.delayed(Duration(seconds: 5))
    ];
    await Future.wait(futures);
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }));
              }),
          IconButton(
              icon: Icon(Icons.email),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Dialog Title"),
                        content: Text("Dialog Content"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel")),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Confirm"))
                        ],
                      );
                    });
              })
        ],
      ),

      ///TODO we should solve the item color when click the navigation item.
      drawer: DrawerItem(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                "Home",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.email),
              title: Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.phone),
              title: Text(
                "Phone",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
        onTap: (index) {
          setState(() {
            _selectionIndex = index;
          });
        },
        currentIndex: _selectionIndex,
        selectedItemColor: Colors.blue,
      ),
      body: Center(
        child: _contentPages[_selectionIndex],
      ),
    );
  }
}
