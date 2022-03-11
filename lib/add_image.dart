import 'package:car_rental/constants.dart';
import 'package:car_rental/registration_screen.dart';
import 'package:car_rental/upload.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

class AddImage extends StatefulWidget {
  static const id = 'add_image';
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  String postId = Uuid().v4();
  bool uploading = false;
  double val = 0;
  firebase_storage.Reference ref;

  List<File> _image = [];
  final picker = ImagePicker();
  TextEditingController captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Caption Post',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              setState(() {
                uploading = true;
              });
              createCarPostInFirestore();

              uploadFile().whenComplete(() => Navigator.of(context).pop());
            },
            child: Text(
              'Upload',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 390,
            padding: EdgeInsets.all(4),
            child: GridView.builder(
                itemCount: _image.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                            alignment: Alignment.center,
                            hoverColor: Colors.amber,
                            focusColor: Colors.tealAccent,
                            iconSize: 40.0,
                            icon: Icon(
                              Icons.add_a_photo_outlined,
                            ),
                            onPressed: () =>
                                !uploading ? selectImage(context) : null,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_image[index - 1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                }),
          ),
          uploading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ),
                )
              : Container(),
          Divider(),
          Padding(
            padding: EdgeInsets.only(
              top: 10,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.article_outlined,
              color: Colors.orange,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.multiline,
                controller: captionController,
                decoration: InputDecoration(
                  hintText: 'Add Your Description',
                  border: InputBorder.none,
                ),
                onChanged: (value) {},
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 200.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              label: Text(
                'Use Current Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.blue,
              onPressed: () {},
              icon: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.pin_drop_outlined,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  handleTakePhoto() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text('Create Post'),
          children: [
            SimpleDialogOption(
              child: Text('Photo with Camera'),
              onPressed: handleTakePhoto,
            ),
            SimpleDialogOption(
              child: Text('Image from Gallery'),
              onPressed: chooseImage,
            ),
            SimpleDialogOption(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.doc(user.uid).collection(postId).add({
            'url': value,
            "ownerId": user.uid,
            "postId": postId,
          });
          i++;
        });
        setState(() {
          postId = this.postId;
        });
      });
    }
  }

  createCarPostInFirestore() {
    carsRef.doc(user.uid).collection("userCars").doc(postId).set({
      "carId": postId,
      "ownerId": user.uid,
      "ownerName": ownerName,
      "brandCar": brand,
      'carModel': model,
      "city": city,
      "phoneNumber": phoneNumber,
      "availableFrom": availableFrom.text,
      "availableTo": availableTo.text,
      "timestamp": timestamp,
      "description": captionController.text,
      "likes": {},
    });
    setState(() {
      postId = this.postId;
    });
  }

  clear() {
    availableFrom.clear();
    availableTo.clear();
  }
}
