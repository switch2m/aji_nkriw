import 'package:car_rental/showroom.dart';
import 'package:car_rental/upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:car_rental/components/rounded_button.dart';
import 'package:car_rental/constants.dart';
import 'package:car_rental/data.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseA;
import 'package:modal_progress_hud/modal_progress_hud.dart';

final DateTime timestamp = DateTime.now();
User currentUser;
final usersRef = FirebaseFirestore.instance.collection('users');
var user = firebaseA.FirebaseAuth.instance.currentUser;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = firebaseA.FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  createUserInFirestore() async {
    DocumentSnapshot doc = await usersRef.doc(user.uid).get();

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'id': user.uid,
      'email': user.email,
      'password': password,
      'time': timestamp,
    });
    currentUser = User.fromDocument(doc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 230.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/logo.jpg',
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      createUserInFirestore();

                      Navigator.pushNamed(context, Showroom.id);
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
