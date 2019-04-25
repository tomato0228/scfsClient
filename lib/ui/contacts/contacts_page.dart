import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tomato_scfs/base/_base_widget.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/chat_contacts_entity.dart';
import 'package:tomato_scfs/model/class_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/app.dart';
import 'package:tomato_scfs/ui/chat/chat_page.dart';
import 'package:tomato_scfs/ui/drawer/personal_page.dart';
import 'package:tomato_scfs/util/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/util/utils.dart';

class ContactsPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return ContactsPageState();
  }
}

class ContactsPageState extends BaseWidgetState<ContactsPage> {
  UserData userData;
  List<UserData> _contactsDatas;
  ScrollController _scrollController = new ScrollController();
  List<ClassData> _classDatas;
  List<String> _userTypes = ['学生', '家长', '教师'];
  int _classItem;
  String _typeItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAppBarVisible(false);
    userData = User.singleton.userData;
    if (userData.userType == '教师') _getClasses();
  }

  @override
  Widget getContentWidget(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.deepOrangeAccent,
        backgroundColor: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
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
                      hint: new Text('选择类别'),
                    ),
                    SizedBox(width: 16.0),
                    userData.userType == '教师'
                        ? DropdownButton(
                            onChanged: (value) {
                              setState(() {
                                _classItem = value;
                              });
                            },
                            elevation: 24,
                            items: getClassListData(),
                            value: _classItem,
                            hint: new Text('选择班级'),
                          )
                        : Container(),
                    SizedBox(width: 16.0),
                    Theme(
                      data: Theme.of(context).copyWith(
                        backgroundColor: Theme.of(context).accentColor,
                        buttonTheme: ButtonThemeData(
                          textTheme: ButtonTextTheme.primary,
                          shape: StadiumBorder(),
                        ),
                      ),
                      child: RaisedButton(
                        child: Text('查 询'),
                        onPressed: () {
                          _onRefresh();
                        },
                        splashColor: Colors.grey,
                        elevation: 0.0,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  height: 32.0,
                  // indent: 32.0,
                ),
              ],
            ),
            Container(
              child: (_contactsDatas == null || _contactsDatas.length == 0)
                  ? Container(
                      alignment: Alignment(0.0, 0.0),
                      child: Text(
                        '没有联系人',
                        style: TextStyle(fontSize: 24.0),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, _contactsDatas[index]),
                      itemCount: _contactsDatas.length,
                      shrinkWrap: true,
                      //解决无限高度问题
                      physics: NeverScrollableScrollPhysics(), //禁用滑动事件
                    ),
            ),
          ],
        ),
        onRefresh: _onRefresh,
      ),
    );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => App()),
            (route) => route == null);
  }

  @override
  AppBar getAppBar() {
    // TODO: implement getAppBar
    return AppBar(
      title: Text("ChatContacts"),
      elevation: 0.0,
    );
  }

  Widget buildItem(BuildContext context, UserData contactsData) {
    return ListTile(
      leading: contactsData.userSignature == ''
          ? CircleAvatar(child: Text(contactsData.userName[0]))
          : CircleAvatar(
              backgroundImage: NetworkImage(contactsData.userSignature),
              backgroundColor: Color(0xffff0000),
              radius: 24.0,
            ),
      title: Text(contactsData.userName, style: TextStyle(fontSize: 18.0)),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.phone, color: Colors.black.withOpacity(0.6), size: 16.0),
          SizedBox(width: 5.0),
          Text(contactsData.userTel),
        ],
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PersonalPage(userData: contactsData);
        }));
      },
    );
  }

  /// 班级列表
  List<DropdownMenuItem> getClassListData() {
    List<DropdownMenuItem> items = new List();
    if (_classDatas != null) {
      for (ClassData classData in _classDatas) {
        DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
          child: new Text(classData.className),
          value: classData.classId,
        );
        items.add(dropdownMenuItem);
      }
    }
    return items;
  }

  /// 类别列表
  List<DropdownMenuItem> getTypeListData() {
    List<DropdownMenuItem> items = new List();
    if (_userTypes != null) {
      for (String s in _userTypes) {
        DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
          child: new Text(s),
          value: s,
        );
        items.add(dropdownMenuItem);
      }
    }
    return items;
  }

  Future<void> _onRefresh() async {
    Fluttertoast.showToast(msg: "正在查询...");
    await Future.delayed(Duration(seconds: 2), () {
      if (userData.userType == '教师') {
        getContactsByTeacher();
      } else {
        getContactsByUser();
      }
    });
  }

  Future<Null> getContactsByTeacher() async {
    if (_classItem != null && _typeItem != null) {
      ApiService().getContactsByTeacher((ContactsEntity _contactsEntity) {
        if (_contactsEntity != null && _contactsEntity.status == 0) {
          setState(() {
            _contactsDatas = _contactsEntity.data;
          });
        } else {
          Fluttertoast.showToast(msg: "获取联系人列表失败！");
        }
      }, (Error error) {
        setState(() {
          showError();
        });
      }, userData.userId, _classItem, _typeItem);
    } else {
      Fluttertoast.showToast(msg: "请选择类别和班级！");
    }
  }

  Future<Null> getContactsByUser() async {
    if (_typeItem != null) {
      ApiService().getContactsByUser((ContactsEntity _contactsEntity) {
        if (_contactsEntity != null && _contactsEntity.status == 0) {
          setState(() {
            _contactsDatas = _contactsEntity.data;
          });
        } else {
          Fluttertoast.showToast(msg: "获取联系人列表失败！");
        }
      }, (Error error) {
        setState(() {
          showError();
        });
      }, userData.userId, _typeItem);
    } else {
      Fluttertoast.showToast(msg: "请选择类别！");
    }
  }

  Future<Null> _getClasses() async {
    ApiService().getClassByUserId((ClassEntity _classEntity) {
      if (_classEntity != null && _classEntity.status == 0) {
        setState(() {
          _classDatas = _classEntity.data;
        });
      } else {
        Fluttertoast.showToast(msg: "获取班级列表失败！");
      }
    }, (Error error) {
      setState(() {
        showError();
      });
    }, userData.userId);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }
}
