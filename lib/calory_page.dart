import 'package:flutter/material.dart';

import 'main.dart' as main;
import 'custom_text.dart';


class CaloryPage extends StatefulWidget {

  String title;
  bool language;

  CaloryPage(String title, bool language) {
    this.title = title;
    this.language = language;
  }

  @override
  State<StatefulWidget> createState() => _CaloryPage();
}

class _CaloryPage extends State<CaloryPage> {

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
    'Non': 1,
    'Pas vraiment': 2,
    'Oui': 3
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
  void initState() {
    if(widget.language) {
      setState(() {
        sportFrequence.clear();
        sportFrequence = {
          'No': 1,
          'Not really': 2,
          'Yes': 3
        };
      });
    }
    super.initState();
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
            CustomText(widget.language ? 'Fill all the blanks to see your daily calory needs' : 'Remplissez tous les champs pour calculer vos besoins en calories', color: setColor(),),
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
                        CustomText(widget.language ? 'Female' : 'Femme', color: Colors.green,),
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
                        CustomText(widget.language ? 'Male' : 'Homme', color: Colors.blue,)
                      ],
                    ),
                    RaisedButton(
                      elevation: 5.0,
                      color: setColor(),
                      child: CustomText(date == null ? (widget.language ? 'Tap to enter your age' : 'Appuyez pour entrer votre âge') : (widget.language ? 'Your age : ${age.toString()}' : 'Votre âge : ${age.toString()}')),
                      onPressed: () {
                        calculateAge();                       
                      }
                    ),
                    CustomText(widget.language ? 'Your size : ${sliderValue.toString()} cm' : 'Votre taille : ${sliderValue.toString()} cm', color: setColor(),),
                    Slider(
                      activeColor: setColor(),
                      inactiveColor: gender ? Colors.blue[200] : Colors.green[200],
                      value: sliderValue, 
                      min: 140.0,
                      max: 200.0,
                      divisions: 200 - 140,
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
                        labelText: widget.language ? 'Enter your weight' : 'Entrez votre poids',
                        labelStyle: TextStyle(color: setColor()),
                      ),
                    ),
                    CustomText(
                      widget.language ? 'Are you a sportive person ?' : 'Êtes-vous une personne sportive ?', 
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
              child: CustomText(widget.language ? 'Calculate' : 'Calculer'),
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
            title: CustomText(widget.language ? 'Your daily calory need is :' : 'Votre besoin journalier de calories est :', color: setColor(),),
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    CustomText(widget.language ? 'Without sport : ${caloryWithoutSport.round()}' : 'Sans sport : ${caloryWithoutSport.round()}', color: Colors.black,),
                    CustomText(widget.language ? 'With sport : ${caloryWithSport.round()}' : 'Avec sport : ${caloryWithSport.round()}', color: Colors.black,),
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
            widget.language ? 'Error' : 'Erreur',
            color: Colors.red,
          ),
          content: CustomText(widget.language ? 'You did not fill all the blanks' : "Vous n'avez pas rempli tous les champs", color: Colors.black,),
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
      setState(() {        
        caloryWithoutSport = result;
        caloryWithSport = result;
        radioSelected == 1 ? caloryWithSport *= 1.2 : radioSelected == 2 ? caloryWithSport *= 1.5 : caloryWithSport *= 1.8;
      });

    } else {
      alert();
    }
  }

  Color setColor() {
    return gender ? Colors.blue : Colors.green;
  }
}
