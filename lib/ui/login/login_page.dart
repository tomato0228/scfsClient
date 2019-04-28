import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tomato_scfs/common/application.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/event/login_event.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/app.dart';
import 'package:tomato_scfs/ui/signin/signin_page.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final Color backgroundColor1 = Color(0xFF444152);
  final Color backgroundColor2 = Color(0xFF6f6c7d);
  final Color highlightColor = Color(0xfff65aa3);
  final Color foregroundColor = Colors.white;
  final AssetImage logo = new AssetImage("assets/images/full-bloom.png");

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeNameLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginNameController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      backgroundColor: backgroundColor2,
      duration: Duration(seconds: 3),
    ));
  }

  //登录
  Future<Null> _login() async {
    String username = loginNameController.text;
    String password = loginPasswordController.text;
    if ((null != username && username.trim().length > 0) &&
        (null != password && password.trim().length > 0)) {
      ApiService().login((UserEntity _userEntity, Response response) {
        if (_userEntity != null) {
          if (_userEntity.status == 0) {
            if (_userEntity.total == 0) {
              _overSignin();
            } else {
              User().saveUserInfo(_userEntity, response);
              Application.eventBus.fire(new LoginEvent());
              Fluttertoast.showToast(msg: "登录成功！");
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(builder: (context) => App()),
                  (route) => route == null);
            }
          } else {
            Fluttertoast.showToast(msg: "登陆失败，密码错误！");
          }
        }
      }, (Error error) {
        Fluttertoast.showToast(msg: "登陆失败，请检查网络！");
      }, username, password);
    } else {
      Fluttertoast.showToast(
        msg: "用户名或者密码不能为空！",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment(1.0, 0.0),
            // 10% of the width, so there are ten blinds.
            colors: [this.backgroundColor1, this.backgroundColor2],
            // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 120.0, bottom: 50.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 128.0,
                      width: 128.0,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: this.foregroundColor,
                        radius: 100.0,
                        child: Text(
                          "S",
                          style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: this.foregroundColor,
                          width: 1.0,
                        ),
                        shape: BoxShape.circle,
                        //image: DecorationImage(image: this.logo)
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Samarth Agarwal",
                        style: TextStyle(color: this.foregroundColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: this.foregroundColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.person_outline,
                      color: this.foregroundColor,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  new Expanded(
                    child: TextField(
                      focusNode: myFocusNodeNameLogin,
                      controller: loginNameController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '账号/电话号码/邮箱',
                        hintStyle: TextStyle(
                            color: this.foregroundColor.withOpacity(0.3)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: this.foregroundColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.lock_open,
                      color: this.foregroundColor,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  new Expanded(
                    child: TextField(
                      focusNode: myFocusNodePasswordLogin,
                      controller: loginPasswordController,
                      obscureText: _obscureTextLogin,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '*********',
                        hintStyle: TextStyle(
                            color: this.foregroundColor.withOpacity(0.3)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleLogin,
                    child: Icon(
                      _obscureTextLogin
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 16.0,
                      color: this.foregroundColor,
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      color: this.highlightColor,
                      onPressed: () {
                        _login();
                      },
                      child: Text(
                        "登    陆",
                        style: TextStyle(color: this.foregroundColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      color: Colors.transparent,
                      onPressed: () => {},
                      child: Text(
                        "忘 记 密 码?",
                        style: TextStyle(
                            color: this.foregroundColor.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 0.0, bottom: 0.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      color: Colors.transparent,
                      onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SigninPage()))
                          },
                      child: Text(
                        "没 有 帐 户? 创 建 一 个",
                        style: TextStyle(
                            color: this.foregroundColor.withOpacity(0.5)),
                      ),
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

  //登录密码安全开关
  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  Future _overSignin() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).tip),
          content: Text('登陆失败，请先让您的孩子在他的账户中添加您为家人！'),
          actions: <Widget>[
            FlatButton(
              child:
                  Text(S.of(context).ok, style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    ///
    /// 强制竖屏
    ///
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNodePasswordLogin.dispose();
    myFocusNodeNameLogin.dispose();
  }
}
