import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'components/custom_image.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String url;
  Post({
    this.postId,
    this.ownerId,
    this.url,
  });
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      url: doc['url'],
    );
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        url: this.url,
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String url;

  _PostState({
    this.postId,
    this.ownerId,
    this.url,
  });

  buildPostImage() {
    return GestureDetector(
        child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        cachedNetworkImage(url),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildPostImage(),
      ],
    );
  }
}
