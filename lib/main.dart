import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tweet_app/route_generator.dart';
import 'package:tweet_app/util/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
