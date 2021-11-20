import 'package:flutter/material.dart';
import 'package:tweet_app/util/colors.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: 80.0,
          left: 50.0,
          right: 50.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                "See what's happening \nin the world right now.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.white,
                      onPrimary: primaryColor,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      minimumSize: Size(double.infinity, 45),
                      side: BorderSide(color: Colors.black26, width: 0.5),
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: Text('Create account', style: TextStyle(fontSize: 16.0),),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: primaryColor,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      minimumSize: Size(double.infinity, 45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
