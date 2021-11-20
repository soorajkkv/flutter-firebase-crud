import 'package:cloud_firestore/cloud_firestore.dart';

class TweetModel {
  String? uid;
  String content;
  String userName;
  Timestamp? timeStamp;

  TweetModel({this.uid, required this.content, required this.userName, this.timeStamp});


  factory TweetModel.fromMap(map) {
    return TweetModel(
      uid: map['uid'],
      content: map['content'],
      userName: map['username'],
      timeStamp: map['timestamp'],
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'content': content,
      'username': userName,
      'timestamp': timeStamp,
    };
  }
}
