import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tweet_app/models/tweet_model.dart';
import 'package:tweet_app/models/user_model.dart';
import 'package:tweet_app/services/database_service.dart';
import 'package:tweet_app/util/colors.dart';
import 'package:tweet_app/widgets/loading.dart';
import 'package:tweet_app/widgets/tweet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController contentController = TextEditingController();
  TextEditingController editController = TextEditingController();

  UserModel? currentUser = UserModel();

  String? userName, editUid;

  final _auth = FirebaseAuth.instance;

  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() {
    user = _auth.currentUser;

    if (user == null)
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

    userName = user!.displayName;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    editTweetDialog() {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Text(
                "Edit tweet",
                style: TextStyle(
                  fontSize: 20,
                  color: primaryColor,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          children: [
            Divider(),
            TextFormField(
              controller: editController,
              maxLength: 280,
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
                color: Colors.black,
              ),
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Edit tweet",
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: width,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (editController.text.isNotEmpty) {
                    await DatabaseService()
                        .updateTweet(editUid, editController.text.trim());
                    Navigator.pop(context);
                  }
                },
                child: Text('Update'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: primaryColor,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size(double.infinity, 45),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/icons/twitter_icon.png',
          height: 30.0,
          width: 30.0,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: primaryColor),
            offset: Offset(0, 50),
            onSelected: (value) async {
              if (value == 'logout') {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              }
            },
            itemBuilder: (_) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text('Logout'),
                ),
                value: 'logout',
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<TweetModel>?>(
          stream: DatabaseService().listTweets(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            }
            List<TweetModel>? tweets = snapshot.data;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "All Tweets",
                    style: TextStyle(
                      fontSize: 28,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        height: 10.0,
                        color: Colors.grey,
                      ),
                      itemCount: tweets!.length,
                      itemBuilder: (context, index) {
                        print(tweets[index].uid);
                        return Tweet(
                          text: tweets[index].content,
                          timeAgo: tweets[index].timeStamp,
                          username: tweets[index].userName,
                          uid: tweets[index].uid,
                          onRemoveTap: () =>
                              DatabaseService().removeTweet(tweets[index].uid),
                          onEditTap: () {
                            editController.text = tweets[index].content;
                            editUid = tweets[index].uid;
                            editTweetDialog();
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
        onPressed: () {
          contentController.text = '';
          showDialog(
            context: context,
            builder: (BuildContext context) => SimpleDialog(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(
                    "Create a tweet",
                    style: TextStyle(
                      fontSize: 20,
                      color: primaryColor,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              children: [
                Divider(),
                TextFormField(
                  controller: contentController,
                  maxLength: 280,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.black,
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "What's happening?",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (contentController.text.isNotEmpty) {
                        await DatabaseService().createTweet(TweetModel(
                          content: contentController.text.trim(),
                          userName: userName ?? 'user',
                          uid: user?.uid,
                          timeStamp: Timestamp.now(),
                        ));
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Create'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: primaryColor,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      minimumSize: Size(double.infinity, 45),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
