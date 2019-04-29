import 'package:flutter/material.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/model/notice_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/drawer/about_page.dart';
import 'package:tomato_scfs/ui/drawer/personal_page.dart';
import 'package:tomato_scfs/ui/notice/notice_edit_page.dart';

class NoticeShowPage extends StatelessWidget {
  NoticeData noticeData;

  NoticeShowPage({@required this.noticeData});

  UserData userData = User.singleton.userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通知详情'),
        actions: <Widget>[
          userData.userType == '教师' && userData.userId == noticeData.userId
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push<NoticeData>(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return NoticeEditPage(noticeDate: noticeData);
                    })).then((NoticeData noticeData) {
                      if (noticeData != null) this.noticeData = noticeData;
                    });
                  },
                )
              : Container(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(32.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(noticeData.noticeTitle,
                    style: Theme.of(context).textTheme.title),
                Text(noticeData.noticeDate.substring(0, 16),
                    style: Theme.of(context).textTheme.subhead),
                SizedBox(
                  height: 32.0,
                ),
                Text('通知内容: ', style: Theme.of(context).textTheme.body2),
                Text('       ' + (noticeData.noticeContent),
                    style: Theme.of(context).textTheme.body1),
                SizedBox(
                  height: 16.0,
                ),
                Text('通知附件: ', style: Theme.of(context).textTheme.body2),
                Text(
                    '        ' +
                        (noticeData.noticeAttachment == null ||
                                noticeData.noticeAttachment == ''
                            ? '无附件'
                            : noticeData.noticeAttachment),
                    style: Theme.of(context).textTheme.body1),
                SizedBox(
                  height: 16.0,
                ),
                Text('教师信息:', style: Theme.of(context).textTheme.title),
                Stack(
                  children: <Widget>[
                    Chip(
                      label: ListTile(
                        title: Text(noticeData.userName),
                        subtitle: Text(noticeData.userTel),
                      ),
                      avatar: CircleAvatar(
                        backgroundImage: NetworkImage(noticeData.userSignature),
                        radius: 32.0,
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.3),
                          highlightColor: Colors.white.withOpacity(0.1),
                          onTap: () {
                            if (noticeData.userId != userData.userId) {
                              UserData teacher =
                                  UserData.fromJson(noticeData.toJson());
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return PersonalPage(userData: teacher);
                              }));
                            } else {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return AboutPage();
                              }));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
