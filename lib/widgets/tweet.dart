import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Tweet extends StatelessWidget {
  final String username;
  final Timestamp? timeAgo;
  final String text;
  final String? uid;
  final VoidCallback onRemoveTap;
  final VoidCallback onEditTap;
  const Tweet({
    Key? key,
    required this.username,
    required this.timeAgo,
    required this.text,
    required this.uid,
    required this.onRemoveTap,
    required this.onEditTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetBody(),
        ],
      ),
    );
  }

  Widget tweetBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetHeader(),
          tweetText(),
          tweetButtons(),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }

  Widget tweetHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5.0),
          child: Text(
            "@${this.username}",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          timeago.format(timeAgo!.toDate()),
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget tweetText() {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Text(
        text,
        overflow: TextOverflow.clip,
      ),
    );
  }

  Widget tweetButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0, left: 10.0),
      child: Row(
        children: [
          tweetIconButton(Icons.edit, 'Edit', onEditTap),
          tweetIconButton(Icons.delete, 'Remove', onRemoveTap),
        ],
      ),
    );
  }

  Widget tweetIconButton(IconData icon, String text, VoidCallback onTap) {
    return Row(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            size: 16.0,
            color: Colors.black45,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}
