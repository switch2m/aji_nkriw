import 'package:car_rental/add_image.dart';
import 'package:car_rental/testcode.dart';
import 'package:car_rental/upload.dart';
import 'package:car_rental/login_screen.dart';
import 'package:car_rental/registration_screen.dart';
import 'package:car_rental/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:car_rental/showroom.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.muliTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        Showroom.id: (context) => Showroom(),
        Upload.id: (context) => Upload(),
        AddImage.id: (context) => AddImage(),
        Test.id: (context) => Test(),
      },
    );
  }
}
