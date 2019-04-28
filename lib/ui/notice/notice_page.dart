import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tomato_scfs/base/_base_widget.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/class_entity.dart';
import 'package:tomato_scfs/model/notice_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/app.dart';
import 'package:tomato_scfs/ui/notice/notice_add_page.dart';
import 'package:tomato_scfs/ui/notice/notice_show_page.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class NoticePage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return NoticePageState();
  }
}

class NoticePageState extends BaseWidgetState<NoticePage> {
  List<NoticeData> _noticeDatas;
  List<ClassData> _classDatas;
  List<UserData> _studentDatas;
  int _studentItem;
  UserData userData;
  int _classItem;

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

  /// 学生列表
  List<DropdownMenuItem> getStudentListData() {
    List<DropdownMenuItem> items = new List();
    if (_studentDatas != null) {
      for (UserData userData in _studentDatas) {
        DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
          child: new Text(userData.userName),
          value: userData.userId,
        );
        items.add(dropdownMenuItem);
      }
    }
    return items;
  }

  /// 删除时弹出框
  Future _openAlertDialog(NoticeData noticeData) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('删除通知'),
          content: ListTile(
            title: Text("确认删除该通知吗？"),
            subtitle: Text(
              noticeData.noticeTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('关闭', style: TextStyle(color: Colors.orange)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确认', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                _deleteNotice(noticeData.noticeId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget getNoticeListData() {
    if (_noticeDatas == null || _noticeDatas.length == 0)
      return Container(
        alignment: Alignment(0.0, 0.0),
        child: Text(
          '无通知',
          style: TextStyle(fontSize: 24.0),
        ),
      );
    return ListView(
      shrinkWrap: true, //解决无限高度问题
      physics: NeverScrollableScrollPhysics(), //禁用滑动事件
      children: _noticeDatas.map((notice) {
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(notice.noticeTitle),
                subtitle: Text(notice.noticeDate.substring(0, 16)),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment(0.0, 0.0),
                    child: Text(
                      notice.noticeContent,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white.withOpacity(0.3),
                        highlightColor: Colors.white.withOpacity(0.1),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return NoticeShowPage(noticeData: notice);
                          }));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    userData.userType == '教师'
                        ? FlatButton(
                            child:
                                Text('删除', style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              _openAlertDialog(notice);
                            },
                          )
                        : Container(),
                    FlatButton(
                      child: Text('查看'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return NoticeShowPage(noticeData: notice);
                        }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
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

  Future<Null> _deleteNotice(_noticeId) async {
    ApiService().deleteNoticeByTeacher((BaseEntity _baseEntity) {
      if (_baseEntity != null && _baseEntity.status == 0) {
        Fluttertoast.showToast(msg: "删除通知成功！");
        setState(() {
          _getNotices();
        });
      } else {
        Fluttertoast.showToast(msg: "删除通知失败！");
      }
    }, (Error error) {
      setState(() {
        showError();
      });
    }, _noticeId);
  }

  Future<Null> _getNotices() async {
    if (userData.userType == '教师') {
      if (_classItem != null) {
        ApiService().getNoticeByTeacher((NoticeEntity _noticeEntity) {
          if (_noticeEntity != null && _noticeEntity.status == 0) {
            setState(() {
              _noticeDatas = _noticeEntity.data;
            });
          } else {
            Fluttertoast.showToast(msg: "获取通知列表失败！");
          }
        }, (Error error) {
          setState(() {
            showError();
          });
        }, userData.userId, _classItem);
      } else {
        Fluttertoast.showToast(msg: "请选择班级！");
      }
    } else if (userData.userType == '家长') {
      if (_studentItem != null) {
        ApiService().getNoticeByParents((NoticeEntity _noticeEntity) {
          if (_noticeEntity != null && _noticeEntity.status == 0) {
            setState(() {
              _noticeDatas = _noticeEntity.data;
            });
          } else {
            Fluttertoast.showToast(msg: "获取通知列表失败！");
          }
        }, (Error error) {
          setState(() {
            showError();
          });
        }, userData.userId, _studentItem);
      } else {
        Fluttertoast.showToast(msg: "请选择孩子！");
      }
    } else {
      ApiService().getNotice((NoticeEntity _noticeEntity) {
        if (_noticeEntity != null && _noticeEntity.status == 0) {
          setState(() {
            _noticeDatas = _noticeEntity.data;
          });
        } else {
          Fluttertoast.showToast(msg: "获取通知列表失败！");
        }
      }, (Error error) {
        setState(() {
          showError();
        });
      }, userData.userId);
    }
  }

  /// 家长获取学生
  Future<Null> _getStudentList() async {
    ApiService().getStudentList((ContactsEntity _contactsEntity) {
      if (_contactsEntity != null && _contactsEntity.status == 0) {
        setState(() {
          _studentDatas = _contactsEntity.data;
        });
      } else {
        Fluttertoast.showToast(msg: "获取学生列表失败！");
      }
    }, (Error error) {
      setState(() {
        showError();
      });
    }, userData.userId);
  }

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    userData = User.singleton.userData;
    if (userData.userType == '教师')
      _getClasses();
    else if (userData.userType == '家长')
      _getStudentList();
    else
      _getNotices();
    showContent();
  }

  @override
  Widget getContentWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            userData.userType == '教师'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                            onChanged: (value) {
                              setState(() {
                                _classItem = value;
                              });
                            },
                            elevation: 24,
                            items: getClassListData(),
                            value: _classItem,
                            hint: new Text('选择班级'),
                          ),
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
                                _getNotices();
                              },
                              splashColor: Colors.grey,
                              elevation: 0.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Theme(
                        data: Theme.of(context).copyWith(
                          backgroundColor: Theme.of(context).accentColor,
                          buttonTheme: ButtonThemeData(
                            textTheme: ButtonTextTheme.primary,
                            shape: StadiumBorder(),
                          ),
                        ),
                        child: RaisedButton(
                          child: Text('发 布 新 通 知'),
                          onPressed: () {
                            Navigator.push<String>(context,
                                MaterialPageRoute(builder: (context) {
                              return NoticeAddPage(classDatas: _classDatas);
                            })).then((String s) {
                              _getNotices();
                            });
                          },
                          splashColor: Colors.grey,
                          elevation: 0.0,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 32.0,
                        // indent: 32.0,
                      ),
                    ],
                  )
                : Container(),
            userData.userType == '家长'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                            onChanged: (value) {
                              setState(() {
                                _studentItem = value;
                              });
                            },
                            elevation: 24,
                            items: getStudentListData(),
                            value: _studentItem,
                            hint: new Text('选择孩子'),
                          ),
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
                                _getNotices();
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
                  )
                : Container(),
            getNoticeListData(),
          ],
        ),
      ),
    );
  }

  @override
  void onClickErrorWidget() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => App()),
        (route) => route == null);
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      title: Text("notice"),
      elevation: 0.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
