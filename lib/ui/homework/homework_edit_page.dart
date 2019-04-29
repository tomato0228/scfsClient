import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/homework_entity.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class HomeworkEditPage extends StatefulWidget {
  final HomeworkData homeworkDate;

  HomeworkEditPage({@required this.homeworkDate});

  @override
  HomeworkEditPageState createState() =>
      new HomeworkEditPageState(homeworkDate: homeworkDate);
}

class HomeworkEditPageState extends State<HomeworkEditPage> {
  final HomeworkData homeworkDate;

  HomeworkEditPageState({@required this.homeworkDate});

  String homeworkContent, homeworkAttachment;
  final textHomeworkContentController = TextEditingController();
  final textHomeworkAttachmentController = TextEditingController();

  //布置作业
  Future<Null> _editHomework() async {
    String homeworkContent = textHomeworkContentController.text;
    String homeworkAttachment = textHomeworkAttachmentController.text;
    if ((null != homeworkContent && homeworkContent.trim().length > 0)) {
      if (homeworkAttachment == null) homeworkAttachment = '';
      ApiService().editHomeworkByTeacher((BaseEntity _baseEntity) {
        if (_baseEntity != null) {
          if (_baseEntity.status == 0) {
            Fluttertoast.showToast(msg: "编辑作业成功！");
            homeworkDate.homeworkContent = homeworkContent;
            homeworkDate.homeworkAttachment = homeworkAttachment;
            Navigator.pop(context, homeworkDate);
          } else {
            Fluttertoast.showToast(msg: "编辑作业失败！");
          }
        }
      }, (Error error) {
        print(error.toString());
        Fluttertoast.showToast(
          msg: "编辑作业失败！",
        );
      }, homeworkDate.homeworkId, homeworkContent, homeworkAttachment);
    } else {
      Fluttertoast.showToast(
        msg: "作业内容不能为空！",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑作业'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
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
            SizedBox(height: 32.0),
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
            SizedBox(height: 32.0),
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
                        _editHomework();
                      },
                      child: Text(
                        "提    交",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
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
    super.initState();
    textHomeworkContentController.text = homeworkDate.homeworkContent;
    textHomeworkAttachmentController.text = homeworkDate.homeworkAttachment;
  }

  @override
  void dispose() {
    super.dispose();
    textHomeworkContentController.dispose();
    textHomeworkAttachmentController.dispose();
  }
}
