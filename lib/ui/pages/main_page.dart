import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  var _selectionIndex = 0;

  static const TextStyle _style =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _contentPages = const <Widget>[
    Text("Home Page", style: _style),
    Text("Email Page", style: _style),
    Text("Phone Page", style: _style),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.email), title: Text("Email")),
          BottomNavigationBarItem(
              icon: Icon(Icons.phone), title: Text("Phone")),
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
