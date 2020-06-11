import "package:flutter/material.dart";

TextStyle SimpleTextStyle(){
  return TextStyle(
    color: Colors.black38,
    fontSize: 12,
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: SimpleTextStyle(),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black38)
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
          color: Colors.black38,
      ),
    ),
  );
}