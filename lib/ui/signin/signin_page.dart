import 'package:flutter/material.dart';
import 'package:tomato_scfs/ui/signin/signin_page_two.dart';

class SigninPage extends StatefulWidget {
  @override
  SigninPageState createState() => new SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final Color backgroundColor1 = Color(0xFF444152);
  final Color backgroundColor2 = Color(0xFF6f6c7d);
  final Color highlightColor = Color(0xfff65aa3);
  final Color foregroundColor = Colors.white;
  final AssetImage logo = new AssetImage("assets/images/full-bloom.png");

  bool _switchSex = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: new Alignment(1.0, 0.0),
            // 10% of the width, so there are ten blinds.
            colors: [this.backgroundColor1, this.backgroundColor2],
            // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 150.0, bottom: 50.0),
              child: Center(
                child: new Column(
                  children: <Widget>[
                    Container(
                      height: 128.0,
                      width: 128.0,
                      child: new CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: this.foregroundColor,
                        radius: 100.0,
                        child: new Text(
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
                      child: new Text(
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
              child: new Row(
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
                  new Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
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
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.lock_outline,
                      color: this.foregroundColor,
                    ),
                  ),
                  new Expanded(
                    child: TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '密    码',
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
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                    child: Icon(
                      Icons.lock,
                      color: this.foregroundColor,
                    ),
                  ),
                  new Expanded(
                    child: TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '再次输入密码',
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
//            decoration: BoxDecoration(
//              border: Border(
//                bottom: BorderSide(
//                    color: this.foregroundColor,
//                    width: 0.5,
//                    style: BorderStyle.solid),
//              ),
//            ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
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
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      color: this.highlightColor,
                      onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SigninPageTwo()))
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
            new Expanded(
              child: Divider(),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
