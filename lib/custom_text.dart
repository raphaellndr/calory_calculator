import 'package:flutter/material.dart';

class CustomText extends Text {

  CustomText(String string, {color: Colors.white, textAlign: TextAlign.center, fontSize: 20.0}): 
    super(
      string,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: fontSize)
    );

}