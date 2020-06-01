import 'package:flutter/material.dart';

import 'custom_text.dart';
import 'calory_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calory calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calory calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.language}) : super(key: key);

  final String title;
  final bool language;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool switchLanguage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CustomText(switchLanguage ? widget.title : 'Calculateur de calories',),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                CustomText('Français', color: switchLanguage ? Colors.grey[200] : Colors.black),
                Switch(
                  value: switchLanguage, 
                  activeColor: Colors.black,
                  onChanged: (bool b) {
                    setState(() {
                      switchLanguage = b;
                    });                
                  }
                ),
                CustomText('English', color: switchLanguage ? Colors.black : Colors.grey[200])
              ]
            ),
            RaisedButton(
              onPressed: start,
              color: Colors.grey[800],
              child: CustomText(switchLanguage ? "Discover your daily calories' need" : 'Découvrez votre besoin en calories')
            )
          ],
        ),
      ),
    );
  }

  void start() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return CaloryPage('Calory calculator', switchLanguage);
    }));
  }
}
