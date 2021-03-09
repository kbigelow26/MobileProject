import 'package:flutter/material.dart';
import './main.dart' as homeScreen;

class UpdateFoldersRoute extends StatefulWidget {
  @override
  _UpdateFoldersState createState() => _UpdateFoldersState();
}

class _UpdateFoldersState extends State<UpdateFoldersRoute> {
  Widget getListView() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.folder_outlined),
          title: Text('Dessert'),
          trailing: Icon(Icons.reorder),
        ),
        ListTile(
          leading: Icon(Icons.folder_outlined),
          title: Text('Breakfast'),
          trailing: Icon(Icons.reorder),
        ),
        ListTile(
          leading: Icon(Icons.text_snippet_outlined),
          title: Text('Steak'),
          trailing: Icon(Icons.reorder),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Folders'),
      ),
      body: Center(
        child: getListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => homeScreen.MyHomePage(title: 'Yum Binder')),
          );
        },
        tooltip: 'Go to Create Recipe',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: "Back"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check), label: "Done"),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      homeScreen.MyHomePage(title: 'Yum Binder')),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => homeScreen.MyHomePage(title: 'Yum Binder')),
            );
          }
        },
      ),
    );
  }
}