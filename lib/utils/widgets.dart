import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'colors.dart';

//this is a reusable common button function in all screens.
MaterialButton reUsableButton(
    {required String text,
    // required  onpress
    required void Function()? onPressed}) {
  return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      color: primaryColor,
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ));
}

///Resuable textfields

TextField authTextField(
    {String? labelText,
    bool isVisible = false,
    IconData? prefixIcon,
    Function()? onPressed,
    IconData? obsecureIcon}) {
  return TextField(
    textAlign: TextAlign.center,
    obscureText: isVisible,
    decoration: InputDecoration(
        hintText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon:
            GestureDetector(onTap: onPressed, child: Icon(obsecureIcon)),
        contentPadding: const EdgeInsets.all(10),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15))),
  );
}
