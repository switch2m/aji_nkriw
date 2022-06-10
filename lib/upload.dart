import 'dart:ui';

import 'package:car_rental/add_image.dart';
import 'package:car_rental/components/bottom_navigation_bar.dart' as Bnbar;
import 'package:car_rental/constants.dart';
import 'package:car_rental/testcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final imgRef = FirebaseFirestore.instance.collection('imageURLs');
final Reference storageRef = FirebaseStorage.instance.ref();
final carsRef = FirebaseFirestore.instance.collection('cars');
final String postId = Uuid().v4();

TextEditingController dateinput = TextEditingController();
TextEditingController timeinput = TextEditingController();
TextEditingController availableFrom = TextEditingController();
TextEditingController availableTo = TextEditingController();

class Upload extends StatefulWidget {
  static const id = 'upload';

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  bool isUploading = false;

  Scaffold buildSplashScreen() {
    return Scaffold(
      backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: [
          Container(
            height: 60,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 63.0,
                    top: 10.0,
                  ),
                  child: Text(
                    'General',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: "Signatra",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    top: 10,
                  ),
                  child: Text(
                    'Information',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontFamily: "signatra",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60.0),
              ),
            ),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: TextFieldDeco.copyWith(
                              hintText: 'Enter the car owner name',
                              prefixIcon: Icon(Icons.person)),
                          onChanged: (value) {
                            ownerName = value;
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: TextFieldDeco.copyWith(
                              hintText: 'Enter the car brand',
                              prefixIcon: Icon(
                                Icons.directions_car_filled,
                              )),
                          onChanged: (value) {
                            brand = value;
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: TextFieldDeco.copyWith(
                            hintText: 'Enter the car model name',
                            prefixIcon: Icon(
                              Icons.directions_car_filled,
                            ),
                          ),
                          onChanged: (value) {
                            model = value;
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: TextFieldDeco.copyWith(
                            hintText: 'Enter your city',
                            prefixIcon: Icon(
                              Icons.home_filled,
                            ),
                          ),
                          onChanged: (value) {
                            city = value;
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 30,
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: TextFieldDeco.copyWith(
                            hintText: 'Enter your phone number',
                            prefixIcon: Icon(
                              Icons.phone_android,
                            ),
                          ),
                          onChanged: (value) {
                            phoneNumber = value;
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 120,
                        ),
                        child: Container(
                          height: 40.0,
                          child: Text(
                            'Car Availability',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller:
                              availableFrom, //editing controller of this TextField
                          decoration: TextFieldDeco.copyWith(
                            labelText: "From",
                            prefixIcon: Icon(
                              Icons.calendar_today,
                            ),
                          ),

                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime
                                    .now(), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            TimeOfDay pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context, //context of current state
                            );

                            if (pickedDate != null) {
                              if (pickedTime != null) {
                                DateTime parsedTime = DateFormat.jm().parse(
                                    pickedTime.format(context).toString());
                                //converting to DateTime so that we can further format on different pattern.

                                String formattedTime =
                                    DateFormat('hh:mm aaa').format(parsedTime);
                                print(formattedTime);
                                //output 1970-01-01 22:53:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd  ')
                                        .format(pickedDate);
                                print(formattedDate);
                                setState(() {
                                  dateinput.text = formattedDate;
                                  timeinput.text = formattedTime;
                                  availableFrom.text =
                                      formattedDate + formattedTime;
                                });
                              }
                            }

                            //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            //output 1970-01-01 22:53:00.000
                          },
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller:
                              availableTo, //editing controller of this TextField
                          decoration: TextFieldDeco.copyWith(
                            labelText: "To",
                            prefixIcon: Icon(
                              Icons.calendar_today,
                            ),
                          ),

                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime
                                    .now(), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            TimeOfDay pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context, //context of current state
                            );

                            if (pickedDate != null) {
                              if (pickedTime != null) {
                                DateTime parsedTime = DateFormat.jm().parse(
                                    pickedTime.format(context).toString());
                                //converting to DateTime so that we can further format on different pattern.

                                String formattedTime =
                                    DateFormat('hh:mm aaa').format(parsedTime);
                                print(formattedTime);
                                //output 1970-01-01 22:53:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd  ')
                                        .format(pickedDate);
                                print(formattedDate);
                                setState(() {
                                  dateinput.text = formattedDate;
                                  timeinput.text = formattedTime;
                                  availableTo.text =
                                      formattedDate + formattedTime;
                                });
                              }
                            }

                            //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            //output 1970-01-01 22:53:00.000
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Upload Image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                              ),
                            ),
                            color: Colors.deepOrange,
                            onPressed: () {
                              Navigator.pushNamed(context, AddImage.id);
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'TEST',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                              ),
                            ),
                            color: Colors.deepOrange,
                            onPressed: () {
                              Navigator.pushNamed(context, Test.id);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Bnbar.BottomNavigationBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildSplashScreen();
  }
}
