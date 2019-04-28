import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/notice_entity.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class NoticeEditPage extends StatefulWidget {
  final NoticeData noticeDate;

  NoticeEditPage({@required this.noticeDate});

  @override
  NoticeEditPageState createState() =>
      new NoticeEditPageState(noticeDate: noticeDate);
}

class NoticeEditPageState extends State<NoticeEditPage> {
  final NoticeData noticeDate;

  NoticeEditPageState({@required this.noticeDate});

  String noticeContent, noticeAttachment;
  final textNoticeTitleController = TextEditingController();
  final textNoticeContentController = TextEditingController();
  final textNoticeAttachmentController = TextEditingController();

  //编辑通知
  Future<Null> _editNotice() async {
    String noticeTitle = textNoticeTitleController.text;
    String noticeContent = textNoticeContentController.text;
    String noticeAttachment = textNoticeAttachmentController.text;
    if ((null != noticeTitle && noticeTitle.trim().length > 0) &&
        (null != noticeContent && noticeContent.trim().length > 0)) {
      if (noticeAttachment == null) noticeAttachment = '';
      ApiService().editNoticeByTeacher((BaseEntity _baseEntity) {
        if (_baseEntity != null && _baseEntity.status == 0) {
          Fluttertoast.showToast(msg: "编辑通知成功！");
          noticeDate.noticeContent = noticeContent;
          noticeDate.noticeAttachment = noticeAttachment;
          Navigator.pop(context, noticeDate);
        } else {
          Fluttertoast.showToast(msg: "编辑通知失败！");
        }
      }, (Error error) {
        print(error.toString());
        Fluttertoast.showToast(msg: "编辑通知失败！");
      }, noticeDate.noticeId, noticeTitle, noticeContent, noticeAttachment);
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
        title: Text('编辑通知'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
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
                        _editNotice();
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
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textNoticeTitleController.text = noticeDate.noticeTitle;
    textNoticeContentController.text = noticeDate.noticeContent;
    textNoticeAttachmentController.text = noticeDate.noticeAttachment;
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
