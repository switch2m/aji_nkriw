import 'package:car_rental/post.dart';
import 'package:car_rental/registration_screen.dart';
import 'package:car_rental/upload.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:car_rental/components/bottom_navigation_bar.dart' as bnBar;

class Test extends StatelessWidget {
  static const id = 'test';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: imgRef
          .doc("OqlNpaieX7U1xbz2VuFPZ6J4n043")
          .collection("96ac7875-40a0-4671-a228-f5a5ea2d7b16")
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text("test"),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      post,
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: bnBar.BottomNavigationBar(),
          ),
        );
      },
    );
  }
}
