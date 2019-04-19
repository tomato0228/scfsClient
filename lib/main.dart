import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tomato_scfs/common/application.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/event/change_language_event.dart';
import 'package:tomato_scfs/event/change_theme_event.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/ui/app.dart';
import 'package:tomato_scfs/ui/loading.dart';
import 'package:tomato_scfs/ui/splash_screen.dart';
import 'package:tomato_scfs/util/theme_util.dart';
import 'package:tomato_scfs/util/utils.dart';

void main() {
  getLoginInfo();
  runApp(MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。
    // 写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏。
    // 写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

Future<Null> getLoginInfo() async {
  User.singleton.getUserInfo();
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Color themeColor = ThemeUtils.currentColorTheme;

  // 定义全局 语言代理
  Locale _locale = Locale('zh', '');

  @override
  void initState() {
    super.initState();

    Utils.getColorThemeIndex().then((index) {
      print('color theme index = $index');
      if (index != null) {
        ThemeUtils.currentColorTheme = ThemeUtils.supportColors[index];
        Application.eventBus
            .fire(new ChangeThemeEvent(ThemeUtils.supportColors[index]));
      }
    });

    Utils.getLanguageType().then((type) {
      print('language type = $type');
      if (type != null) {
        setState(() {
          _locale = Locale(type, '');
        });
        Application.eventBus.fire(new ChangeLanguageEvent(type));
      }
    });

    Application.eventBus.on<ChangeThemeEvent>().listen((event) {
      setState(() {
        themeColor = event.color;
      });
    });

    Application.eventBus.on<ChangeLanguageEvent>().listen((event) {
      setState(() {
        _locale = Locale(event.string, '');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "家校通",
      debugShowCheckedModeBanner: false,
      theme:
          new ThemeData(primaryColor: themeColor, brightness: Brightness.light),
      routes: <String, WidgetBuilder>{
        "app": (BuildContext context) => new App(),
        "splash": (BuildContext context) => new SplashScreen(),
      },
      //   new
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      home: LoadingPage(),
    );
  }
}
