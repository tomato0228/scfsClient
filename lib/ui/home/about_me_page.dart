import 'package:flutter/material.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/util/utils.dart';

class AboutMyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutMyPageState();
  }
}

class AboutMyPageState extends State<AboutMyPage> {
  UserData userData;
  TextStyle textStyle = TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.combine([TextDecoration.underline]),
  );

  @override
  void initState() {
    super.initState();
    userData = new UserData(
      userSex: '男',
      userAddr: '江苏省南京市玄武区孝陵卫200号',
      userEmail: 'tomato@njust.edu.cn',
      userTel: '17723903527',
      userBirth: '1996-02-28',
      userProfile: '家校通，让沟通零距离。',
      userName: '蕃茄酱',
      userId: 0,
      userType: '作者',
      userSignature: 'tomato0228',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).aboutAuthor),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(35, 50, 35, 15),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: CircleAvatar(
                minRadius: 60,
                maxRadius: 60,
                backgroundImage: AssetImage(Utils.getImgPath('myhead')),
                backgroundColor: Color(0xffff0000),
              ),
              onTap: () {},
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            GestureDetector(
              child: LimitedBox(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
                child: Text(userData.userProfile == null
                    ? '点击设置个性签名'
                    : userData.userProfile),
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
                          ? '点击设置生日'
                          : userData.userBirth.substring(0, 10)),
                      onTap: () {},
                    ),
                    Text('    '),
                    GestureDetector(
                      child: Text(userData.userSex),
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
                            ? '点击设置邮箱'
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
                        userData.userTel == null ? '点击设置电话' : userData.userTel,
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
                            ? '点击设置地址'
                            : userData.userAddr,
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
                    Text("Blog："),
                    LimitedBox(
                      maxWidth: MediaQuery.of(context).size.width * 0.63,
                      child: Text('https://www.readmore.ltd',
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
                    Text("GitHub："),
                    LimitedBox(
                      maxWidth: MediaQuery.of(context).size.width * 0.63,
                      child: Text('https://github.com/tomato0228',
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
              '基于移动互联网的家校沟通系统',
              style: TextStyle(fontSize: 12.0),
            )
          ],
        ),
      ),
    );
  }
}
