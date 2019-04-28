import 'package:flutter/material.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/pub/webview_page.dart';
import 'package:tomato_scfs/util/utils.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  UserData userData;
  TextStyle textStyle = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.combine([TextDecoration.underline]),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData = User.singleton.userData;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appPersonal),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(35, 50, 35, 15),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: userData.userSignature == ''
                    ? CircleAvatar(
                        minRadius: 60,
                        maxRadius: 60,
                        child: Text(
                          userData.userName[0],
                          style: TextStyle(fontSize: 52),
                        ),
                      )
                    : CircleAvatar(
                        minRadius: 60,
                        maxRadius: 60,
                        backgroundImage: NetworkImage(userData.userSignature),
                        backgroundColor: Color(0xffff0000),
                        radius: 24.0,
                      ),
                onTap: () {},
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              GestureDetector(
                child: LimitedBox(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                  child: Text(userData.userProfile == null
                      ? '点击设置个性签名'
                      : userData.userProfile),
                ),
                onTap: () {},
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                child: ListTile(
                  title: GestureDetector(
                    child: Text(userData.userName),
                    onTap: () {},
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Text(userData.userBirth == null
                            ? '点击设置生日'
                            : userData.userBirth.substring(0, 10)),
                        onTap: () {},
                      ),
                      Text('    '),
                      GestureDetector(
                        child: Text(userData.userSex),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(18.0, 10.0, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text("邮箱："),
                      LimitedBox(
                        maxWidth: MediaQuery.of(context).size.width * 0.63,
                        child: Text(
                          userData.userEmail == null
                              ? '点击设置邮箱'
                              : userData.userEmail,
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(18.0, 10.0, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text("电话："),
                      LimitedBox(
                        maxWidth: MediaQuery.of(context).size.width * 0.63,
                        child: Text(
                          userData.userTel == null
                              ? '点击设置电话'
                              : userData.userTel,
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(18.0, 10.0, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text("地址："),
                      LimitedBox(
                        maxWidth: MediaQuery.of(context).size.width * 0.63,
                        child: Text(
                          userData.userAddr == null
                              ? '点击设置地址'
                              : userData.userAddr,
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
              Expanded(child: Container(), flex: 1),
              Text(
                '',
                style: TextStyle(fontSize: 12.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context);
    return Future.value(false);
  }
}
