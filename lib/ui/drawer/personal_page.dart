import 'package:flutter/material.dart';
import 'package:tomato_scfs/model/chat_contacts_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/chat/chat_page.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class PersonalPage extends StatefulWidget {
  final UserData userData;
  final bool isShowFB;

  PersonalPage({@required this.userData, this.isShowFB: true});

  @override
  State<StatefulWidget> createState() {
    return PersonalPageState(userData: userData, isShowFB: isShowFB);
  }
}

class PersonalPageState extends State<PersonalPage> {
  final UserData userData;
  final bool isShowFB;

  PersonalPageState({@required this.userData, this.isShowFB: true});

  TextStyle textStyle = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.combine([TextDecoration.underline]),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(userData.userName),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(35, 50, 35, 15),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: CircleAvatar(
                  minRadius: 60,
                  maxRadius: 60,
                  backgroundImage: NetworkImage(userData.userSignature),
                ),
                onTap: () {},
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              GestureDetector(
                child: LimitedBox(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                  child: Text(
                    userData.userProfile == null
                        ? '未设置个性签名'
                        : userData.userProfile,
                    textAlign: TextAlign.center,
                  ),
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
                            ? '未设置生日'
                            : userData.userBirth.substring(0, 10)),
                        onTap: () {},
                      ),
                      Text('    '),
                      GestureDetector(
                        child: Text(userData.userSex == null
                            ? '未设置性别'
                            : userData.userSex),
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
                              ? '未设置邮箱'
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
                          userData.userTel == null ? '未设置电话' : userData.userTel,
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
                              ? '未设置地址'
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
        floatingActionButton: isShowFB
            ? FloatingActionButton(
                child: Icon(Icons.local_post_office),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) {
                    return ChatPage(
                        chatContactsData:
                            ChatContactsData.fromJson(userData.toJson()));
                  }));
                },
                backgroundColor: ThemeUtils.currentColorTheme,
              )
            : Container(),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context);
    return Future.value(false);
  }
}
