import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/ui/contacts/supporter_list.dart';
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

  var pages = <Widget>[
    ListPage(),
    Scaffold(),
    NoticePage(),
    HomeworkPage(),
    Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    final appBarTitles = [
      S.of(context).appHomePage,
      S.of(context).appAddressBook,
      S.of(context).appMessage,
      S.of(context).appHomework,
      S.of(context).appPersonal
    ];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: DrawerPage(),
        appBar: AppBar(
          title: new Text(appBarTitles[_selectedIndex]),
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
        body: new IndexedStack(
          children: pages,
          index: _selectedIndex,
        ),

        //底部导航按钮 包含图标及文本
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(S.of(context).appHomePage),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              title: Text(S.of(context).appAddressBook),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: Text(S.of(context).appMessage),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text(S.of(context).appHomework),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(S.of(context).appPersonal),
            ),
          ],
          type: BottomNavigationBarType.fixed, //设置显示的模式
          currentIndex: _selectedIndex, //当前选中项的索引
          onTap: _onItemTapped, //选择按下处理
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
          builder: (context) => new AlertDialog(
                title: new Text(S.of(context).tip),
                content: new Text(S.of(context).exitAppTip),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(S.of(context).cancel),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text(S.of(context).exit),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
