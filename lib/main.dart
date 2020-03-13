import 'package:flutter/material.dart';
import 'package:flutter_alphabet_sample/indexed_list_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {

  final itemHeight = 50.0;

  final items = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Brazil",
    "Indonesia",
    "Netherlands",
    "USA",
  ];

  String title;

  MyHomePage({
    @required
    this.title
  });

  Widget itemWidget(BuildContext context, int index) {
    return Text(items[index]);
  }

  Widget titleWidget(BuildContext context) {
    return Text(
      "Country List",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24.0
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          titleWidget(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IndexedListView(
                itemHeight: itemHeight,
                items: items,
                itemBuilder: itemWidget,
              ),
            ),
          )
        ],
      )
    );
  }
}
