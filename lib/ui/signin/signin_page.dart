import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/ui/signin/signin_page_two.dart';

class SigninPage extends StatefulWidget {
  @override
  SigninPageState createState() => new SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final Color backgroundColor1 = Colors.white;
  final Color backgroundColor2 = Colors.white70;
  final Color highlightColor = Colors.black;
  final Color foregroundColor = Colors.black87;
  final AssetImage logo = new AssetImage("assets/images/logo.png");

  bool _switchSex = false;
  bool _obscureTextPass = true;
  bool _obscureTextPassAgain = true;

  List<String> _userTypes = ['家长']

      /*['学生', '家长', '教师']*/;

  String _typeItem = '家长';
  TextEditingController userNameController = new TextEditingController();
  TextEditingController userPasswordController = new TextEditingController();
  TextEditingController userPasswordAgainController =
      new TextEditingController();
  String userBirth =
      DateTime.now().toString().substring(0, "yyyy-MM-dd".length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.centerLeft,
//            end: Alignment(1.0, 0.0),
//            // 10% of the width, so there are ten blinds.
//            colors: [this.backgroundColor1, this.backgroundColor2],
//            // whitish to gray
//            tileMode: TileMode.repeated, // repeats the gradient over the canvas
//          ),
//        ),
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
                  /// 姓名
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
                            Icons.person_outline,
                            color: this.foregroundColor,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        new Expanded(
                          child: TextField(
                            controller: userNameController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '姓    名',
                              hintStyle: TextStyle(
                                  color: this.foregroundColor.withOpacity(0.3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 密码
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
                            Icons.lock_outline,
                            color: this.foregroundColor,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        new Expanded(
                          child: TextField(
                            controller: userPasswordController,
                            obscureText: _obscureTextPass,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '密    码',
                              hintStyle: TextStyle(
                                  color: this.foregroundColor.withOpacity(0.3)),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _obscureTextPass
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 16.0,
                            color: this.foregroundColor,
                          ),
                          onPressed: _togglePass,
                        ),
//                        GestureDetector(
//                          onTap: _togglePass,
//                          child: Icon(
//                            _obscureTextPass
//                                ? FontAwesomeIcons.eye
//                                : FontAwesomeIcons.eyeSlash,
//                            size: 16.0,
//                            color: this.foregroundColor,
//                          ),
//                        ),
                      ],
                    ),
                  ),

                  /// 再次输入密码
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
                            Icons.lock,
                            color: this.foregroundColor,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        new Expanded(
                          child: TextField(
                            controller: userPasswordAgainController,
                            obscureText: _obscureTextPassAgain,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '再次输入密码',
                              hintStyle: TextStyle(
                                color: this.foregroundColor.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _obscureTextPassAgain
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 16.0,
                            color: this.foregroundColor,
                          ),
                          onPressed: _togglePassAgain,
                        ),
//                        GestureDetector(
//                          onTap: _togglePassAgain,
//                          child: Icon(
//                            _obscureTextPassAgain
//                                ? FontAwesomeIcons.eye
//                                : FontAwesomeIcons.eyeSlash,
//                            size: 16.0,
//                            color: this.foregroundColor,
//                          ),
//                        ),
                      ],
                    ),
                  ),

                  /// 性别
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 00.0),
                          child: Icon(
                            Icons.supervised_user_circle,
                            color: this.foregroundColor,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _switchSex ? '女' : '男',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: this.foregroundColor.withOpacity(0.8),
                                ),
                              ),
                              Icon(
                                _switchSex
                                    ? Icons.pregnant_woman
                                    : Icons.accessibility_new,
                                color: this.foregroundColor.withOpacity(0.8),
                              ),
                              Switch(
                                value: _switchSex,
                                onChanged: (value) {
                                  setState(() {
                                    _switchSex = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 生日
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 00.0),
                          child: Icon(
                            Icons.cake,
                            color: this.foregroundColor,
                          ),
                        ),
                        new Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: _selectDate,
                                child: Row(
                                  children: <Widget>[
                                    Text(userBirth),
                                    Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 类别
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 40.0, right: 40.0, top: 10.0),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 00.0),
                          child: Icon(
                            Icons.group_work,
                            color: this.foregroundColor,
                          ),
                        ),
                        new Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DropdownButton(
                                onChanged: (value) {
                                  setState(() {
                                    _typeItem = value;
                                  });
                                },
                                elevation: 24,
                                items: getTypeListData(),
                                value: _typeItem,
                                hint: Text('选择类别'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 注册
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
                              _signin();
//                        Navigator.of(context).push(MaterialPageRoute(
//                            builder: (context) => SigninPage()));
                            },
                            child: Text(
                              "注    册",
                              style: TextStyle(color: this.foregroundColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// 登陆
            Container(
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
                      onPressed: () => {Navigator.of(context).pop()},
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

  _signin() {
    String userName = userNameController.text.trim();
    String userPassword = userPasswordController.text.trim();
    String userPasswordAgain = userPasswordAgainController.text.trim();
    String userSex = _switchSex ? '女' : '男';
    if (userName.length == 0) {
      Fluttertoast.showToast(msg: '请输入姓名！');
    } else if (userPassword.length == 0) {
      Fluttertoast.showToast(msg: '请输入密码！');
    } else if (userPasswordAgain.length == 0) {
      Fluttertoast.showToast(msg: '请确认密码！');
    } else if (!RegexUtil.matches(
        '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{8,16}\$', userPassword)) {
      Fluttertoast.showToast(msg: '密码长度：8--16', timeInSecForIos: 3);
    } else if (userPassword != userPasswordAgain) {
      Fluttertoast.showToast(msg: '两次密码不一致！');
    } else {
      ApiService().signin((BaseEntity _baseEntity) {
        if (_baseEntity != null) {
          if (_baseEntity.status == 0) {
            Fluttertoast.showToast(msg: "注册成功！");
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return SigninPageTwo(userId: _baseEntity.data);
            }));
          } else {
            Fluttertoast.showToast(msg: "注册失败，请重试！");
          }
        }
      }, (Error error) {
        Fluttertoast.showToast(msg: "注册失败，请检查网络！");
      }, userName, userPassword, _typeItem, userSex, userBirth);
    }
  }

  Future<void> _selectDate() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date == null) return;
      setState(() {
        userBirth = date.toString().substring(0, "yyyy-MM-dd".length);
      });
    });
  }

  /// 类别列表
  List<DropdownMenuItem> getTypeListData() {
    List<DropdownMenuItem> items = new List();
    if (_userTypes != null) {
      for (String s in _userTypes) {
        DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
          child: Text(s),
          value: s,
        );
        items.add(dropdownMenuItem);
      }
    }
    return items;
  }

  //密码安全开关
  void _togglePass() {
    setState(() {
      _obscureTextPass = !_obscureTextPass;
    });
  }

  //确认密码安全开关
  void _togglePassAgain() {
    setState(() {
      _obscureTextPassAgain = !_obscureTextPassAgain;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
