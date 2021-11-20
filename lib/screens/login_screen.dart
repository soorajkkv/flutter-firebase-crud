import 'package:flutter/material.dart';
import 'package:tweet_app/services/auth_service.dart';
import 'package:tweet_app/util/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // string for displaying the error Message
  String? errorMessage;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
      ),
    );

    final loginButton = ElevatedButton(
      onPressed: isLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                await AuthService()
                    .signIn(emailController.text, passwordController.text)
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  if (value)
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  else {
                    final snackBar = SnackBar(
                      content: const Text('Failed to Sign In!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              }
            },
      child: isLoading
          ? CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(
              'Login',
              style: TextStyle(fontSize: 16.0),
            ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: primaryColor,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        minimumSize: Size(double.infinity, 45),
      ),
    );

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
        leading: IconButton(
          icon: Icon(Icons.close, color: primaryColor),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "To get started, enter \nyour email & password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
