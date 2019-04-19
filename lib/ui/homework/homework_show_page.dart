import 'package:flutter/material.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/model/homework_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/homework/homework_edit_page.dart';

// ignore: must_be_immutable
class HomeworkShowPage extends StatelessWidget {
  HomeworkData homeworkData;

  HomeworkShowPage({@required this.homeworkData});

  UserData userData = User.singleton.userData;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('作业详情'),
        actions: <Widget>[
          userData.userType == '教师'
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push<HomeworkData>(context,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return HomeworkEditPage(homeworkDate: homeworkData);
                    })).then((HomeworkData homeworkData) {
                      if (homeworkData != null)
                        this.homeworkData = homeworkData;
                    });
                  },
                )
              : Container(),
        ],
//        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(32.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(homeworkData.courseName,
                    style: Theme.of(context).textTheme.title),
                Text(homeworkData.homeworkDate.substring(0, 10),
                    style: Theme.of(context).textTheme.subhead),
                SizedBox(
                  height: 32.0,
                ),
                Text('作业内容: ', style: Theme.of(context).textTheme.body2),
                Text('       ' + (homeworkData.homeworkContent),
                    style: Theme.of(context).textTheme.body1),
                SizedBox(
                  height: 16.0,
                ),
                Text('作业附件: ', style: Theme.of(context).textTheme.body2),
                Text(
                    '        ' +
                        (homeworkData.homeworkAttachment == null ||
                                homeworkData.homeworkAttachment == ''
                            ? '无附件'
                            : homeworkData.homeworkAttachment),
                    style: Theme.of(context).textTheme.body1),
                SizedBox(
                  height: 16.0,
                ),
                Text('教师信息:', style: Theme.of(context).textTheme.title),
                Stack(
                  children: <Widget>[
                    Chip(
                      label: ListTile(
                        title: Text(homeworkData.userName),
                        subtitle: Text(homeworkData.userTel),
                        //trailing: Text(homeworkData.userEmail),
                      ),
                      avatar: CircleAvatar(
                        backgroundImage:
                            NetworkImage(homeworkData.userSignature),
                        radius: 32.0,
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.3),
                          highlightColor: Colors.white.withOpacity(0.1),
                          onTap: () {},
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
