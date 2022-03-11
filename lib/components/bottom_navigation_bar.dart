import 'package:car_rental/showroom.dart';
import 'package:car_rental/testcode.dart';
import 'package:car_rental/upload.dart';
import 'package:flutter/material.dart';

class BottomNavigationBar extends StatelessWidget {
  const BottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.teal.shade400,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Showroom.id);
            },
            icon: Icon(
              Icons.home_outlined,
              size: 25.0,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Upload.id);
            },
            icon: Icon(
              Icons.add,
              size: 25.0,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Test.id);
            },
            icon: Icon(
              Icons.notifications_outlined,
              size: 25.0,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person_outline,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
