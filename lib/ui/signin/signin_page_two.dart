import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/signin/signin_code.dart';

/// 墨水瓶（`InkWell`）可用时使用的字体样式。
final TextStyle _availableStyle = TextStyle(
  fontSize: 16.0,
  color: const Color(0xFF00CACE),
);

/// 墨水瓶（`InkWell`）不可用时使用的样式。
final TextStyle _unavailableStyle = TextStyle(
  fontSize: 16.0,
  color: const Color(0xFFCCCCCC),
);

class SigninPageTwo extends StatefulWidget {
  final int userId;

  SigninPageTwo({@required this.userId});

  @override
//  SigninPageTwoState createState() => new SigninPageTwoState(userId: userId);
  SigninPageTwoState createState() => new SigninPageTwoState();
}

class SigninPageTwoState extends State<SigninPageTwo> {
//  final int userId;

//  SigninPageTwoState({@required this.userId});

  final Color backgroundColor1 = Colors.white;
  final Color backgroundColor2 = Colors.white70;
  final Color highlightColor = Colors.black;
  final Color foregroundColor = Colors.black87;
  final AssetImage logo = new AssetImage("assets/images/logo.png");

  TextEditingController userTelController = new TextEditingController();
  TextEditingController validationCodeController = new TextEditingController();

  bool _available = false;
  String userTel;
  int validationCode;

  @override
  void initState() {
    super.initState();
    userTel = '';
    validationCode = 0;
    userTelController.addListener(() {
      userTel = userTelController.text.trim();
      if (_available && !RegexUtil.isMobileExact(userTel)) {
        setState(() {
          _available = false;
        });
      } else if (!_available && RegexUtil.isMobileExact(userTel)) {
        _verifyUserAcc();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.centerLeft,
//            end: Alignment(1.0, 0.0),
//            // 10% of the width, so there are ten blinds.
//            colors: [this.backgroundColor1, this.backgroundColor2],
//            // whitish to gray
//            tileMode: TileMode.repeated, // 在画布上重复渐变
//          ),
//        ),
//        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 80.0, bottom: 10.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 128.0,
                      width: 128.0,
//                      child: CircleAvatar(
//                        backgroundColor: Colors.transparent,
//                        foregroundColor: this.foregroundColor,
//                        radius: 100.0,
//                        child: Text(
//                          "S",
//                          style: TextStyle(
//                            fontSize: 50.0,
//                            fontWeight: FontWeight.w100,
//                          ),
//                        ),
//                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: this.foregroundColor,
                            width: 1.0,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(image: this.logo)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "家 校 通",
                        style: TextStyle(
                          color: this.foregroundColor,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView(
                children: <Widget>[
                  Container(
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
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 00.0),
                          child: Icon(
                            Icons.phone,
                            color: this.foregroundColor,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        new Expanded(
                          child: TextField(
                            controller: userTelController,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '电话号码',
                              hintStyle: TextStyle(
                                  color: this.foregroundColor.withOpacity(0.3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
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
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 00.0),
                          child: Icon(
                            Icons.security,
                            color: this.foregroundColor,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        new Expanded(
                          child: TextField(
                            controller: validationCodeController,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '验证码',
                              hintStyle: TextStyle(
                                  color: this.foregroundColor.withOpacity(0.3)),
                            ),
                          ),
                        ),
                        SigninFormCode(
                          countdown: 60,
                          onTapCallback: () {
                            _sendValidationCode();
                          },
                          available: _available,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 30.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          child: OutlineButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            color: this.highlightColor,
                            onPressed: () {
                              _sfz();
                            },
                            child: Text(
                              "绑 定 手 机",
                              style: TextStyle(color: this.foregroundColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          child: FlatButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            color: Colors.transparent,
                            onPressed: () {},
                            child: Text(
                              "绑 定 邮 箱",
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
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      color: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "已 有 账 户? 登 陆",
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

  /// 绑定手机号
  Future<Null> _sfz() async {
    String validation = validationCodeController.text.trim();
    if (!_available) {
      Fluttertoast.showToast(msg: "请输入正确手机号码！");
    } else if (validationCode == 0) {
      Fluttertoast.showToast(msg: "请获取验证码！");
    } else if (validation.length == 0) {
      Fluttertoast.showToast(msg: "请输入验证码！");
    } else if (validation.length != 6 ||
        validation != validationCode.toString()) {
      Fluttertoast.showToast(msg: "验证码不正确！");
    } else {
      ApiService().userUpdateTel((UserEntity _userEntity, Response response) {
        if (_userEntity != null) {
          if (_userEntity.status == 0) {
//            Fluttertoast.showToast(msg: "绑定手机号码成功，自动登陆！");
//            User().saveUserInfo(_userEntity, response);
//            Application.eventBus.fire(new LoginEvent());
//            Navigator.of(context).pushAndRemoveUntil(
//                new MaterialPageRoute(builder: (context) => App()),
//                    (_) => false);
            _overSignin();
          } else {
            Fluttertoast.showToast(msg: "绑定失败，请重试！");
          }
        }
      }, (Error error) {
        Fluttertoast.showToast(msg: "绑定失败，请检查网络！");
      }, widget.userId, userTel);
    }
  }

  /// 发送验证码
  Future<Null> _sendValidationCode() async {
    ApiService().sendValidationCode((BaseEntity _baseEntity) {
      if (_baseEntity != null) {
        if (_baseEntity.status == 0) {
          Fluttertoast.showToast(msg: "验证码已发送，请注意查收！");
          print(_baseEntity.data);
          validationCode = _baseEntity.data;
        } else {
          Fluttertoast.showToast(msg: "验证码发送失败，请重试！");
        }
      }
    }, (Error error) {
      Fluttertoast.showToast(msg: "验证码发送失败，请检查网络！");
    }, widget.userId, userTel);
  }

  /// 检测电话号码是否存在
  Future<Null> _verifyUserAcc() async {
    print('111');
    ApiService().verifyUserAcc((BaseEntity _baseEntity) {
      if (_baseEntity != null && _baseEntity.status == 0) {
        print(_baseEntity.data);
        if (_baseEntity.data == 0) {
          setState(() {
            _available = true;
          });
        } else {
          Fluttertoast.showToast(msg: "手机号码已存在，请重新输入！");
          userTelController.text = userTel.substring(0, 10);
        }
      }
    }, (Error error) {
      Fluttertoast.showToast(msg: "验证失败，请检查网络！");
    }, userTel);
  }

  Future _overSignin() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).tip),
          content: Text('绑定成功，请让您的孩子在他的账户中添加您为家人！'),
          actions: <Widget>[
            FlatButton(
              child:
                  Text(S.of(context).ok, style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
