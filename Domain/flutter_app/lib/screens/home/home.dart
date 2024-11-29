import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../services/mapview_screen.dart';
import 'package:flutter_app/globals.dart' as globals;
import 'package:invert_colors/invert_colors.dart';
import 'package:flutter_app/screens/services/auth.dart';

Color drawerBgColor;
Color textColor;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool status = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Widget bodyWidget;

  @override
  void initState(){
    super.initState();
    bodyWidget = light();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if(globals.isDarkMode){
      drawerBgColor = Color(0xFF232A4D);
      textColor = Color(0xFFCCCCCC);
      bodyWidget = dark();
    }
    else{
      drawerBgColor = Color(0x00232A4D);
      textColor = Color(0xFF000000);
      bodyWidget = light();
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)
        ),
        clipBehavior: Clip.hardEdge,
        child: _CheckDrawer(user)
      ),
      body: bodyWidget,
      floatingActionButton: _floatingButton,
    );
  }


  Widget dark(){
    print("dark");
    return InvertColors(
        child:Stack(
          children: <Widget>[
            MapView(),
            _hamburgerButton,
          ],
        )
    );
  }

  Widget light(){
    print("light");
    return Stack(
      children: <Widget>[
        MapView(),
        _hamburgerButton,
      ],
    );
  }

  Widget _CheckDrawer(user) {
    final AuthService _auth = AuthService();

    if (user == null)
      return Drawer(
          child: Container(
            color: drawerBgColor,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 15),
                ListTile(
                    leading: Icon(
                      Icons.account_circle, size: 50,
                      color: globals.isDarkMode? Colors.white70 : Colors.black87,
                    ),
                    title: Container(
                      child: Text(
                          '로그인해주세요.',
                        style: TextStyle(
                          color: globals.isDarkMode? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                    onTap: (){
                      AuthService().signInWithGoogle();
                    }
                ),
                ListTile(
                  leading: Icon(
                      Icons.settings,
                      size: 35,
                    color: globals.isDarkMode? Colors.white70 : Colors.black87,
                  ),
                  title: Container(
                    child: Text(
                      '설정',
                      style: TextStyle(
                        color: globals.isDarkMode? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO: 앱 설정 추가
                  },
                ),
                SwitchListTile(
                  title: Text(
                      "다크모드",
                    style: TextStyle(
                      color: globals.isDarkMode? Colors.white70 : Colors.black87,
                    ),
                  ),
                  secondary: Icon(Icons.nights_stay_rounded, size: 35,
                    color: globals.isDarkMode? Colors.white70 : Colors.black87,
                  ),
                  value: globals.isDarkMode,
                  onChanged: (bool value) {
                    setState((){
                      globals.isDarkMode = value;
                    });
                  },
                ),
              ],
            ),
          )
      );
    else
      return Drawer(
          child: Container(
            color: drawerBgColor,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 15),
                ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 23,
                        //backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                    ),
                    title: Container(
                      child: Text(
                        user.displayName,
                        style: TextStyle(
                          color: globals.isDarkMode? Colors.white70 : Colors.black87,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    onTap: (){
                      AuthService().signInWithGoogle();
                    }
                ),
                ListTile(
                  leading: Icon(Icons.logout,
                    color: globals.isDarkMode? Colors.white70 : Colors.black87,
                  ),
                  title: Text(
                      'Logout',
                    style: TextStyle(
                      color: globals.isDarkMode? Colors.white70 : Colors.black87,
                    ),
                  ),
                  onTap: () async {
                    //Navigator.pushNamed(context, '/kakaologin');
                    await _auth.signOut();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.money,
                    color: globals.isDarkMode? Colors.white70 : Colors.black87,
                  ),
                  title: Text(
                      'Reward',
                    style: TextStyle(
                      color: globals.isDarkMode? Colors.white70 : Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context); // close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, size: 35,
                    color: globals.isDarkMode? Colors.white70 : Colors.black87,
                  ),
                  title: Container(
                    child: Text(
                      '설정',
                      style: TextStyle(
                        color: globals.isDarkMode? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO: 앱 설정 추가
                  },
                ),
                SwitchListTile(
                  title: Text(
                      "다크모드",
                    style: TextStyle(
                      color: globals.isDarkMode? Colors.white70 : Colors.black87,
                    ),
                  ),
                  secondary: Icon(Icons.nights_stay_rounded, size: 35,
                    color: globals.isDarkMode? Colors.white70 : Colors.black87,
                  ),
                  value: globals.isDarkMode,
                  onChanged: (bool value) {
                    setState((){
                      globals.isDarkMode = value;
                    });
                  },
                ),
              ],
            ),
          )
      );
  }

  Widget get _floatingButton {
    return FloatingActionButton(
      // 우측하단 플로팅버튼 표시
      onPressed: () {
          Navigator.pushNamed(context, '/register_smoking_area');
      }, //todo
      child: Icon(Icons.add),
      backgroundColor: globals.isDarkMode ? Colors.black45 : Colors.white,
      foregroundColor: Colors.black87,
    );
  }

  Widget get _hamburgerButton {
    return Positioned(
      // 햄버거버튼 표시
      top: 30,
      left: 10,
      child: IconButton(
        icon: Icon(Icons.menu),
        iconSize: 30,
        color: Colors.black,
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
    );
  }

}
