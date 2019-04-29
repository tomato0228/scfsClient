import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/ui/app.dart';
import 'package:tomato_scfs/ui/login/login_page.dart';

//加载页面
class LoadingPage extends StatefulWidget {
  @override
  _LoadingState createState() => new _LoadingState();
}

class _LoadingState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    //在加载页面停顿2秒
    new Future.delayed(Duration(seconds: 3), () {
      _getHasSkip();
    });
  }

  void _getHasSkip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSkip = prefs.getBool("hasSkip");
    if (hasSkip == null || !hasSkip) {
      Navigator.of(context).pushReplacementNamed("splash");
    } else {
      if (User.singleton.userData != null) {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => App()), (_) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => LoginPage()),
            (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          "assets/images/loading.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
