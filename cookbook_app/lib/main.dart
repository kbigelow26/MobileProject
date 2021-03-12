import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:developer';
import './createRecipeScreen.dart' as createRecipeScreen;
import './updateFoldersScreen.dart' as updateFoldersScreen;
import './searchRecipeScreen.dart' as searchRecipeScreen;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Yum Binder'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget getListView() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.folder),
          title: Text('Dessert'),
        ),
        ListTile(
          leading: Icon(Icons.folder),
          title: Text('Breakfast'),
        ),
        ListTile(
          leading: Icon(Icons.text_snippet),
          title: Text('Steak'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: getListView(),
      ),
      drawer: Drawer(  // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
        //child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Text('Yum Binder'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Public Recipes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => searchRecipeScreen.SearchRecipeRoute()),
                );
              },
            ),
            ListTile(
              title: Text('Share a Recipe'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Update Folders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => updateFoldersScreen.UpdateFoldersRoute()),
                );
              },
            ),
            ListTile(
              title: Text('Create a Recipe'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => createRecipeScreen.CreateRecipeRoute()),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => createRecipeScreen.CreateRecipeRoute()),
          );
        },
        tooltip: 'Go to Create Recipe',
        child: Icon(Icons.add),
      ),
    );
  }
}
