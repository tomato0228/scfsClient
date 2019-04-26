import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tomato_scfs/common/application.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/event/change_language_event.dart';
import 'package:tomato_scfs/event/change_theme_event.dart';
import 'package:tomato_scfs/event/login_event.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/drawer/about_page.dart';
import 'package:tomato_scfs/ui/login/login_page.dart';
import 'package:tomato_scfs/ui/school/school_page.dart';
import 'package:tomato_scfs/util/theme_util.dart';
import 'package:tomato_scfs/util/utils.dart';

class DrawerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new DrawerPageState();
  }
}

class DrawerPageState extends State<DrawerPage> {
  UserData userData;

  @override
  void initState() {
    super.initState();
    userData = User.singleton.userData;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: InkWell(
              child: Text(
                userData.userName ?? '点击设置名字',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              onTap: () {},
            ),
            accountEmail: InkWell(
              child: Text(
                userData.userEmail ?? '点击设置邮箱',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {},
            ),
            currentAccountPicture: InkWell(
              child: CircleAvatar(
                backgroundImage: NetworkImage(userData.userSignature),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'http://gss0.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/6c224f4a20a44623d34fcf2b9a22720e0df3d7f6.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.grey[400].withOpacity(0.6), BlendMode.hardLight),
              ),
            ),
          ),
          ListTile(
            title: Text(
              S.of(context).appPersonal,
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.person, size: 22.0),
            onTap: () {
              onCollectionClick();
            },
          ),
          ListTile(
            title: Text(
              S.of(context).language,
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.language, size: 22.0),
            onTap: () {
              openLanguageSelectMenu();
            },
          ),
          ListTile(
            title: Text(
              S.of(context).theme,
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.color_lens, size: 22.0),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return new SimpleDialog(
                    title: Text(S.of(context).theme),
                    children: ThemeUtils.supportColors.map((Color color) {
                      return new SimpleDialogOption(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                          height: 35,
                          color: color,
                        ),
                        onPressed: () {
                          ThemeUtils.currentColorTheme = color;
                          Utils.setColorTheme(
                              ThemeUtils.supportColors.indexOf(color));
                          changeColorTheme(color);
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text(
              S.of(context).school,
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.school, size: 22.0),
            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return SchoolPage();
              }));
            },
          ),
          userData.userType == '学生'
              ? ListTile(
                  title: Text(
                    S.of(context).addParents,
                    textAlign: TextAlign.left,
                  ),
                  leading: Icon(Icons.group_add, size: 22.0),
                  onTap: () {
                    onCollectionClick();
                  },
                )
              : Container(),
          ListTile(
            title: Text(
              S.of(context).aboutAuthor,
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.info, size: 22.0),
            onTap: () {},
          ),
          logoutWidget()
        ],
      ),
    );
  }

  Widget logoutWidget() {
    if (User.singleton.userData != null) {
      return ListTile(
        title: Text(
          S.of(context).logOut,
          textAlign: TextAlign.left,
        ),
        leading: Icon(Icons.power_settings_new, size: 22.0),
        onTap: () {
          User.singleton.clearUserInfo();
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        },
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  void onCollectionClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return AboutPage();
    }));
  }

  changeColorTheme(Color c) {
    Application.eventBus.fire(new ChangeThemeEvent(c));
  }

  changeLanguageType(String s) {
    Application.eventBus.fire(new ChangeLanguageEvent(s));
  }

  /// 国际化
  void openLanguageSelectMenu() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: Text('中文'),
                onTap: () {
                  Utils.setLanguageType('zh');
                  changeLanguageType('zh');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('English'),
                onTap: () {
                  Utils.setLanguageType('en');
                  changeLanguageType('en');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
