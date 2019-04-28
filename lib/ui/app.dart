import 'dart:async';

import 'package:bottom_tab_bar/bottom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:tomato_scfs/common/application.dart';
import 'package:tomato_scfs/event/change_badgeno_event.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/ui/contacts/chat_contacts_page.dart';
import 'package:tomato_scfs/ui/contacts/contacts_page.dart';
import 'package:tomato_scfs/ui/drawer/drawer.dart';
import 'package:tomato_scfs/ui/homework/homework_page.dart';
import 'package:tomato_scfs/ui/notice/notice_page.dart';

//应用页面使用有状态Widget
class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

//应用页面状态实现类
class AppState extends State<App> {
  int _selectedIndex = 0; //当前选中项的索引

  double elevation = 4.0;

  String badgeNoS;

  void setBadgeNo({badgeNo: 0}) {
    setState(() {
      if (badgeNo == 0) {
        badgeNoS = '';
      } else if (badgeNo > 99) {
        badgeNoS = '99+';
      } else {
        badgeNoS = badgeNo.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    badgeNoS = '';
    Application.eventBus.on<ChangeBadeNoEvent>().listen((event) {
      setBadgeNo(badgeNo: event.badgeNo);
    });
  }

  var pages = <Widget>[
    ChatContactsPage(),
    ContactsPage(),
    NoticePage(),
    HomeworkPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final appBarTitles = [
      S.of(context).appHomePage,
      S.of(context).appAddressBook,
      S.of(context).appMessage,
      S.of(context).appHomework
    ];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: DrawerPage(),
        appBar: AppBar(
          title: Text(appBarTitles[_selectedIndex]),
          bottom: null,
          elevation: elevation,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return Scaffold();
                  }));
                })
          ],
        ),
        body: IndexedStack(
          children: pages,
          index: _selectedIndex,
        ),

        //底部导航按钮 包含图标及文本
        bottomNavigationBar: BottomTabBar(
          items: <BottomTabBarItem>[
            BottomTabBarItem(
              icon: Icon(Icons.home),
              title: Text(S.of(context).appHomePage),
              badgeNo: badgeNoS,
            ),
            BottomTabBarItem(
              icon: Icon(Icons.contacts),
              title: Text(S.of(context).appAddressBook),
            ),
            BottomTabBarItem(
              icon: Icon(Icons.volume_up),
              title: Text(S.of(context).appMessage),
            ),
            BottomTabBarItem(
              icon: Icon(Icons.library_books),
              title: Text(S.of(context).appHomework),
            ),
          ],
          badgeColor: Colors.blue,
          type: BottomTabBarType.fixed,
          //设置显示的模式
          currentIndex: _selectedIndex,
          //当前选中项的索引
          onTap: _onItemTapped, //选择按下处理
//          isAnimation: false,
//          isInkResponse: false,
        ),
      ),
    );
  }

  //选择按下处理 设置当前索引为index值
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
//      if (index == 2 || index == 4) {
//        elevation = 0.0;
//      } else {
//        elevation = 4.0;
//      }
      elevation = 4.0;
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(S.of(context).tip),
                content: Text(S.of(context).exitAppTip),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(S.of(context).cancel),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(S.of(context).exit),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
