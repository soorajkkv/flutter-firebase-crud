import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tweet_app/models/user_model.dart';

class AuthService {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  UserModel? getLoggedInUser() {
    User? user = FirebaseAuth.instance.currentUser;
    usersCollection.doc(user!.uid).get().then((value) {
      return UserModel.fromMap(value.data());
    });
  }

  // login API
  Future<bool> signIn(String email, String password) async {
    final _auth = FirebaseAuth.instance;
    String errorMessage;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (error) {
      print(error.code);
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      return false;
    }
  }

// sign up API
  Future<bool> signUp(String email, String password, username) async {
    final _auth = FirebaseAuth.instance;
    String errorMessage;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        postDetailsToFirestore(username);
      });
      return true;
    } on FirebaseAuthException catch (error) {
      print(error.code);
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
       return false;
    }
    
  }

// create user profile API
  postDetailsToFirestore(String username) async {

    final _auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing data
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.userName = username.trim();

    await user.updateDisplayName(username.trim());

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

  }
}
