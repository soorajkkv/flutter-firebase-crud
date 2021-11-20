import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tweet_app/models/tweet_model.dart';

class DatabaseService {
  CollectionReference tweetsCollection =
      FirebaseFirestore.instance.collection("tweets");

  Future createTweet(TweetModel tweet) async {
    return await tweetsCollection.add(tweet.toMap());
  }

  Future updateTweet(uid, String content) async {
    await tweetsCollection.doc(uid).update({"content": content});
  }

  Future removeTweet(uid) async {
    await tweetsCollection.doc(uid).delete();
  }

  List<TweetModel>? tweetFromFirestore(QuerySnapshot snapshot) {
    if (snapshot.size > 0) {
      return snapshot.docs.map((e) {
        return TweetModel(
          userName: e.get("username"),
          content: e.get("content"),
          uid: e.id,
          timeStamp: e.get('timestamp'),
        );
      }).toList();
    } else {
      return null;
    }
  }


  Stream<List<TweetModel>?>? listTweets() {
    return tweetsCollection.orderBy('timestamp', descending: true).snapshots().map(tweetFromFirestore);
  }
}
