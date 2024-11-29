import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/SmokingArea.dart';
import 'package:flutter_app/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  //파이어베이스 인증 클래스의 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Firestore firestore = Firestore.instance;
  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(
            uid: user.uid,
            photoUrl: user.photoUrl,
            displayName: user.displayName,
            email: user.email)
        : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    User result = _userFromFirebaseUser(user);
    addUser(result);
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
  }

  void addUser(User user) {
    //해당 uid가 이미 등록되어있는지 검사
    firestore.collection('users').document(user.email).get()
    .then((DocumentSnapshot ds) {
      if (!ds.exists)
        firestore.collection('users').document(user.email).setData({'reward': 0});
    });
  }

/* 흡연구역 쿼리 전송 */

  SmokingArea SetSmokingArea(String text, double lat, double long, String url) {
    return SmokingArea(text: text, latitude: lat, longitude: long, imgurl: url);
  }
  void addArea(SmokingArea smk) {
    firestore.collection('smokingarea').document().setData({'text': smk.text, 'latitude': smk.latitude, 'longitude': smk.longitude, 'imgurl': smk.imgurl});
  }

}
