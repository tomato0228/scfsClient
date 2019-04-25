import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/class_entity.dart';
import 'package:tomato_scfs/model/course_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/util/theme_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeworkAddPage extends StatefulWidget {
  final List<CourseData> courseDatas;
  final List<ClassData> classDatas;

  HomeworkAddPage({
    @required this.courseDatas,
    @required this.classDatas,
  });

  @override
  HomeworkAddPageState createState() => new HomeworkAddPageState(
        classDatas: classDatas,
        courseDatas: courseDatas,
      );
}

class HomeworkAddPageState extends State<HomeworkAddPage> {
  final List<CourseData> courseDatas;
  final List<ClassData> classDatas;

  HomeworkAddPageState({
    @required this.courseDatas,
    @required this.classDatas,
  });

  String homeworkContent, homeworkAttachment;
  UserData userData;
  int _courseItem;
  int _classItem;
  final textHomeworkContentController = TextEditingController();
  final textHomeworkAttachmentController = TextEditingController();

  List<DropdownMenuItem> getCourseListData() {
    List<DropdownMenuItem> items = new List();
    if (courseDatas != null) {
      for (CourseData sourseData in courseDatas) {
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
    if (classDatas != null) {
      for (ClassData classData in classDatas) {
        DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
          child: new Text(classData.className),
          value: classData.classId,
        );
        items.add(dropdownMenuItem);
      }
    }
    return items;
  }

  //布置作业
  Future<Null> _addHomework() async {
    String homeworkContent = textHomeworkContentController.text;
    String homeworkAttachment = textHomeworkAttachmentController.text;
    if ((null != homeworkContent && homeworkContent.trim().length > 0)) {
      if (homeworkAttachment == null) {
        homeworkAttachment = '';
      }
      print(homeworkAttachment);
      if (_courseItem == null || _classItem == null) {
        Fluttertoast.showToast(
          msg: "请选择班级和科目！",
        );
      } else {
        ApiService().addHomeworkByTeacher((BaseEntity _baseEntity) {
          if (_baseEntity != null && _baseEntity.status == 0) {
            Fluttertoast.showToast(msg: "布置作业成功！");
            Navigator.pop(context, "");
          } else {
            Fluttertoast.showToast(msg: "布置作业失败！");
          }
        }, (Error error) {
          print(error.toString());
          Fluttertoast.showToast(
            msg: "布置作业失败！",
          );
        }, userData.userId, _classItem, _courseItem, homeworkContent,
            homeworkAttachment);
      }
    } else {
      Fluttertoast.showToast(
        msg: "作业内容不能为空！",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('布置作业'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DropdownButton(
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
                  ),
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
                ],
              ),
              Divider(
                color: Colors.grey,
                height: 32.0,
                // indent: 32.0,
              ),
              TextField(
                controller: textHomeworkContentController,
                maxLength: 255,
                maxLines: 8,
                //最大行数
                decoration: InputDecoration(
                  icon: Icon(Icons.event_note, size: 32.0),
                  labelText: '内容',
                  hintText: '请输入作业的内容',
                  border: OutlineInputBorder(),
                  //filled: true, //背景颜色
                ),
              ),
              TextField(
                controller: textHomeworkAttachmentController,
                maxLength: 255,
                decoration: InputDecoration(
                  icon: Icon(Icons.insert_link, size: 32.0),
                  labelText: '附件',
                  hintText: '请输入作业附件的地址',
                  border: OutlineInputBorder(),
                  //filled: true, //背景颜色
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 48.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        color: ThemeUtils.currentColorTheme,
                        onPressed: () {
                          _addHomework();
                        },
                        child: Text(
                          "提    交",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: ThemeUtils.currentColorTheme,
        ),
        resizeToAvoidBottomPadding: false, //输入框抵住键盘
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData = User.singleton.userData;
//    textHomeworkContentController.addListener(() {
//      debugPrint('输入: ${textHomeworkContentController.text}');
//    });
//    textHomeworkAttachmentController.addListener(() {
//      debugPrint('输入: ${textHomeworkAttachmentController.text}');
//    });
//    textHomeworkContentController.text = "a";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textHomeworkContentController.dispose();
    textHomeworkAttachmentController.dispose();
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context);
    return Future.value(false);
  }
}
