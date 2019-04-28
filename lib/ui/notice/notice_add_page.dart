import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/class_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class NoticeAddPage extends StatefulWidget {
  final List<ClassData> classDatas;

  NoticeAddPage({
    @required this.classDatas,
  });

  @override
  NoticeAddPageState createState() => new NoticeAddPageState(
        classDatas: classDatas,
      );
}

class NoticeAddPageState extends State<NoticeAddPage> {
  final List<ClassData> classDatas;

  NoticeAddPageState({
    @required this.classDatas,
  });

  String noticeContent, noticeAttachment;
  UserData userData;
  int _classItem;
  final textNoticeTitleController = TextEditingController();
  final textNoticeContentController = TextEditingController();
  final textNoticeAttachmentController = TextEditingController();

  List<DropdownMenuItem> getClassListData() {
    List<DropdownMenuItem> items = new List();
    if (classDatas != null) {
      for (ClassData classData in classDatas) {
        DropdownMenuItem dropdownMenuItem = new DropdownMenuItem(
          child: Text(classData.className),
          value: classData.classId,
        );
        items.add(dropdownMenuItem);
      }
    }
    return items;
  }

  //发布通知
  Future<Null> _addNotice() async {
    String noticeTitle = textNoticeTitleController.text;
    String noticeContent = textNoticeContentController.text;
    String noticeAttachment = textNoticeAttachmentController.text;
    if ((null != noticeTitle && noticeTitle.trim().length > 0) &&
        (null != noticeContent && noticeContent.trim().length > 0)) {
      if (noticeAttachment == null) noticeAttachment = '';
      if (_classItem == null) {
        Fluttertoast.showToast(msg: "请选择班级！");
      } else {
        ApiService().addNoticeByTeacher((BaseEntity _baseEntity) {
          if (_baseEntity != null && _baseEntity.status == 0) {
            Fluttertoast.showToast(msg: "发布通知成功！");
            Navigator.pop(context, "");
          } else {
            Fluttertoast.showToast(msg: "发布通知失败！");
          }
        }, (Error error) {
          print(error.toString());
          Fluttertoast.showToast(msg: "发布通知失败！");
        }, userData.userId, _classItem, noticeTitle, noticeContent,
            noticeAttachment);
      }
    } else {
      Fluttertoast.showToast(
        msg: "通知标题和内容不能为空！",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发布通知'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
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
                  hint: Text('选择班级'),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              height: 32.0,
              // indent: 32.0,
            ),
            TextField(
              controller: textNoticeTitleController,
              maxLength: 20,
              decoration: InputDecoration(
                icon: Icon(Icons.title, size: 32.0),
                labelText: '标题',
                hintText: '请输入通知的标题',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: textNoticeContentController,
              maxLength: 255,
              maxLines: 8,
              //最大行数
              decoration: InputDecoration(
                icon: Icon(Icons.event_note, size: 32.0),
                labelText: '内容',
                hintText: '请输入通知的内容',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: textNoticeAttachmentController,
              maxLength: 255,
              decoration: InputDecoration(
                icon: Icon(Icons.insert_link, size: 32.0),
                labelText: '附件',
                hintText: '请输入通知附件的地址',
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 48.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      color: ThemeUtils.currentColorTheme,
                      onPressed: () {
                        _addNotice();
                      },
                      child: Text(
                        "发    布",
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
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData = User.singleton.userData;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textNoticeTitleController.dispose();
    textNoticeContentController.dispose();
    textNoticeAttachmentController.dispose();
  }
}
