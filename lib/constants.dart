import 'package:flutter/material.dart';

String brand;
String model;
String phoneNumber;
String city;
String ownerName;
Color kPrimaryColor = Color(0xFF7033FF);
Color kPrimaryColorShadow = Color(0xFFF1EBFF);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const TextFieldDeco = InputDecoration(
  hintText: 'Enter the car brand please',
  hintStyle: TextStyle(
    fontSize: 18.0,
  ),
  contentPadding: EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(32.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blueAccent,
      width: 1.7,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blueAccent,
      width: 2.6,
    ),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  prefixIcon: Padding(
    padding: const EdgeInsetsDirectional.only(start: 12.0),
    child: Icon(
      Icons.account_circle_outlined,
      size: 20.0,
    ), // myIcon is a 48px-wide widget.
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
