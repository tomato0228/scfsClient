import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tomato_scfs/base/_base_widget.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/class_entity.dart';
import 'package:tomato_scfs/model/homework_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/model/course_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/homework/homework_add_page.dart';
import 'package:tomato_scfs/ui/homework/homework_show_page.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class HomeworkPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return HomeworkPageState();
  }
}

class HomeworkPageState extends BaseWidgetState<HomeworkPage> {
  List<HomeworkData> _homeworkDatas;
  List<CourseData> _courseDatas;
  List<ClassData> _classDatas;
  UserData userData;
  int _courseItem;
  int _classItem;

  List<DropdownMenuItem> getCourseListData() {
    List<DropdownMenuItem> items = new List();
    if (_courseDatas != null) {
      for (CourseData sourseData in _courseDatas) {
        DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
          child: new Text(sourseData.courseName),
          value: sourseData.courseId,
        );
        items.add(dropdownMenuItem);
      }
    }
    return items;
  }

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

  Future _openAlertDialog(HomeworkData homeworkData) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('删除作业'),
          content: ListTile(
            title: Text("确认删除该作业吗？"),
            subtitle: Text(
              homeworkData.homeworkContent,
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
                _deleteHomework(homeworkData.homeworkId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget getHomeworkListData() {
    if (_homeworkDatas == null || _homeworkDatas.length == 0)
      return Container(
        alignment: Alignment(0.0, 0.0),
        child: Text(
          '无作业',
          style: TextStyle(fontSize: 24.0),
        ),
      );
    return ListView(
      shrinkWrap: true, //解决无限高度问题
      physics: NeverScrollableScrollPhysics(), //禁用滑动事件
      children: _homeworkDatas.map((homework) {
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(homework.courseName),
                subtitle: Text(homework.homeworkDate.substring(0, 10)),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment(0.0, 0.0),
                    child: Text(
                      homework.homeworkContent,
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
                            return HomeworkShowPage(homeworkData: homework);
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
                              _openAlertDialog(homework);
                            },
                          )
                        : Container(),
                    FlatButton(
                      child: Text('查看'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return HomeworkShowPage(homeworkData: homework);
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

  Future<Null> _getCourses() async {
    ApiService().getCourseByUserId((CourseEntity _courseEntity) {
      if (_courseEntity != null && _courseEntity.status == 0) {
        setState(() {
          _courseDatas = _courseEntity.data;
        });
      } else {
        Fluttertoast.showToast(msg: "获取科目列表失败！");
      }
    }, (TypeError error) {
      setState(() {
        showError();
      });
    }, userData.userId);
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
    }, (TypeError error) {
      setState(() {
        showError();
      });
    }, userData.userId);
  }

  Future<Null> _deleteHomework(_homeworkId) async {
    ApiService().deleteHomeworkByTeacher((BaseEntity _baseEntity) {
      if (_baseEntity != null && _baseEntity.status == 0) {
        Fluttertoast.showToast(msg: "删除作业成功！");
        setState(() {
          _getHomeworks();
        });
      } else {
        Fluttertoast.showToast(msg: "删除作业失败！");
      }
    }, (TypeError error) {
      setState(() {
        showError();
      });
    }, _homeworkId);
  }

  Future<Null> _getHomeworks() async {
    if (userData.userType == '教师') {
      if (_courseItem != null && _classItem != null) {
        ApiService().getHomeworkByTeacher((HomeworkEntity _homeworkEntity) {
          if (_homeworkEntity != null && _homeworkEntity.status == 0) {
            setState(() {
              _homeworkDatas = _homeworkEntity.data;
            });
          } else {
            Fluttertoast.showToast(msg: "获取作业列表失败！");
          }
        }, (TypeError error) {
          setState(() {
            showError();
          });
        }, userData.userId, _classItem, _courseItem);
      } else {
        Fluttertoast.showToast(msg: "请选择班级和科目！");
      }
    } else {
      if (_courseItem != null) {
        ApiService().getHomework((HomeworkEntity _homeworkEntity) {
          if (_homeworkEntity != null && _homeworkEntity.status == 0) {
            setState(() {
              _homeworkDatas = _homeworkEntity.data;
            });
          } else {
            Fluttertoast.showToast(msg: "获取作业列表失败！");
          }
        }, (TypeError error) {
          setState(() {
            showError();
          });
        }, userData.userId, _courseItem);
      } else {
        Fluttertoast.showToast(msg: "请选择科目！");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAppBarVisible(false);
    userData = User.singleton.userData;
    _getCourses();
    if (userData.userType == '教师') _getClasses();
    showContent();
  }

  @override
  Widget getContentWidget(BuildContext context) {
    // TODO: implement getContentWidget
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                userData.userType == '教师'
                    ? DropdownButton(
                        onChanged: (value) {
                          setState(() {
                            _classItem = value;
                            print(_classItem);
                          });
                        },
                        elevation: 24,
                        items: getClassListData(),
                        value: _classItem,
                        hint: new Text('选择班级'),
                      )
                    : Container(),
                SizedBox(width: 16.0),
                DropdownButton(
                  onChanged: (value) {
                    setState(() {
                      _courseItem = value;
                      print(_courseItem);
                    });
                  },
                  elevation: 24,
                  items: getCourseListData(),
                  value: _courseItem,
                  hint: new Text('选择科目'),
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
                      _getHomeworks();
                    },
                    splashColor: Colors.grey,
                    elevation: 0.0,
//                  textColor: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
            userData.userType == '教师' ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                    child: Text('布 置 作 业'),
                    onPressed: () {
                      Navigator.push<String>(context,
                          MaterialPageRoute(builder: (context) {
                            return HomeworkAddPage(
                                classDatas: _classDatas, courseDatas: _courseDatas);
                          })).then((String s) {
                        _getHomeworks();
                      });
                    },
                    splashColor: Colors.grey,
                    elevation: 0.0,
                  ),
                ),
              ],
            ) : Container(),
            Divider(
              color: Colors.grey,
              height: 32.0,
              // indent: 32.0,
            ),
            getHomeworkListData(),
          ],
        ),
      ),
    );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
    showloading();
  }

  @override
  AppBar getAppBar() {
    // TODO: implement getAppBar
    return AppBar(
      title: Text("homework"),
      elevation: 0.0,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
