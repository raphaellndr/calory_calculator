import 'package:flutter/material.dart';

import 'custom_text.dart';

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
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool gender = false;
  DateTime date;
  int age;
  double sliderValue = 150.0;
  String submitted;
  int radioSelected;

  double caloryWithSport;
  double caloryWithoutSport;

  bool error = true;

  Map sportFrequence = {
    'No': 1,
    'Not really': 2,
    'Yes': 3
  };

  List<Widget> sport() {
    List<Widget> l = [];
    sportFrequence.forEach((key, value) {
      Column column = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CustomText(
            key, 
            color: setColor(), 
            fontSize: 15.0,
          ),
          Radio(
            value: value, 
            activeColor: setColor(),
            groupValue: radioSelected, 
            onChanged: (Object o) {
              setState(() {
                radioSelected = o;
              });              
            }
          )
        ],
      );
      l.add(column);     
    });
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: setColor(),
        centerTitle: true,
        title: Text(widget.title,),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CustomText('Fill all the blanks to see your daily calories need', color: setColor(),),
            Padding(padding: EdgeInsets.all(10.0)),
            Card(
              elevation: 15.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomText('Female', color: Colors.green,),
                        Switch(
                          value: gender, 
                          inactiveTrackColor: Colors.green[200],
                          inactiveThumbColor: Colors.green,
                          onChanged: (bool b) {
                            setState(() {
                              gender = b;
                            });
                          }
                        ),
                        CustomText('Male', color: Colors.blue,)
                      ],
                    ),
                    RaisedButton(
                      elevation: 5.0,
                      color: setColor(),
                      child: Text(date == null ? 'Tap to enter your age' : 'Your age : ${age.toString()}'),
                      onPressed: () {
                        calculateAge();                       
                      }
                    ),
                    CustomText('Your size : ${sliderValue.toString()} cm', color: setColor(),),
                    Slider(
                      activeColor: setColor(),
                      inactiveColor: gender ? Colors.blue[200] : Colors.green[200],
                      value: sliderValue, 
                      min: 0.0,
                      max: 210.0,
                      divisions: 210,
                      onChanged: (double d) {
                        setState(() {
                          sliderValue = d;
                        });
                      }
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (String string) {
                        submitted = string;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter your weight',
                        labelStyle: TextStyle(color: setColor()),
                      ),
                    ),
                    CustomText(
                      'Are you a sportive person ?', 
                      color: setColor()
                    ),
                    Row(children: sport(), mainAxisAlignment: MainAxisAlignment.spaceEvenly,)
                  ],
                ),
              ),
            ),
            RaisedButton(
              elevation: 5.0,
              color: setColor(),
              child: Text('Calculate'),
              onPressed: () {
                calculation();
                compute();             
              }
            ),
          ],
        ),        
      ),
    );
  }

  Future<Null> calculateAge() async {
    DateTime choice = await showDatePicker(
      context: context, 
      initialDatePickerMode: DatePickerMode.year,
      initialDate: DateTime.now(), 
      firstDate: DateTime(1950), 
      lastDate: DateTime(2021)
    );
    if(choice != null) {
      setState(() {
        date = choice;
      });      
    }
    DateTime currentDate = DateTime.now();
    setState(() {
      age = currentDate.year - date.year;
    });    
    if(currentDate.month < date.month) {
      updateAge(); 
    } else if(currentDate.month == date.month) {
      if(currentDate.day < date.day) {
        updateAge();       
      }
    }
  }

  void updateAge() {
    setState(() {
      age--;
    });
  }

  Future<Null> calculation() async {
    if(!error) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: CustomText('Your daily calory need is :', color: setColor(),),
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    CustomText('Without sport : $caloryWithoutSport', color: Colors.black,),
                    CustomText('With sport : $caloryWithSport', color: Colors.black,),
                    RaisedButton(
                      color: setColor(),
                      onPressed:() {
                        Navigator.pop(context);
                      }, 
                      child: CustomText('Ok'),
                    )
                  ],
                ),
              )
            ],
          );
        }
      );
    }
  }

  Future<Null> alert() async {
    setState(() {
      error = true;
    });
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(
            'Error',
            color: Colors.red,
          ),
          content: Text('You did not fill all the blanks'),
          actions: <Widget>[
            FlatButton(
              onPressed:() {
                Navigator.pop(context);
              },
              child: CustomText('Ok', color: Colors.red,),
            )
          ],
        );
      }
    );
  }

  void compute() {
    double result = 0.0;   

    if(gender != null && submitted != null && sliderValue != null && age != null && radioSelected != null) {
      setState(() {
        error = false;
      });
      if(gender) {
        result = 66.4730 + 13.7516 * int.parse(submitted) + 5.0033 * sliderValue - 6.7550 * age;
      } else {
        result = 655.0955 + 9.5634 * int.parse(submitted) + 1.8496 * sliderValue - 4.6756 * age;
      }
      result.round();
      setState(() {
        caloryWithoutSport = result;
        caloryWithSport = result;
      });

      if(radioSelected == 1) {
        setState(() {
          caloryWithSport *= 1.2;
        });
      } else if(radioSelected == 2) {
        setState(() {
          caloryWithSport *= 1.5;
        });
      } else {
        setState(() {
          caloryWithSport *= 1.8;
        });
      }    
    } else {
      alert();
    }
  }

  Color setColor() {
    return gender ? Colors.blue : Colors.green;
  }
}
