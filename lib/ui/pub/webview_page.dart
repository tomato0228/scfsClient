import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class WebViewPage extends StatefulWidget {
  String title;
  String url;

  WebViewPage({
    Key key,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WebViewPageState();
  }
}

class WebViewPageState extends State<WebViewPage> {
  bool isLoad = true;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    flutterWebviewPlugin.onStateChanged.listen((state) {
      debugPrint("state:_" + state.type.toString());
      if (state.type == WebViewState.finishLoad) {
        setState(() {
          isLoad = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }

//  Future<bool> _requestPop() {
//    //相当于Android的setResult
//    Navigator.pop(context, "返回给上一个页面的测试数据");
//    return new Future.value(false);
//  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: WebviewScaffold(
        url: widget.url,
        appBar: AppBar(
          elevation: 0.4,
          title: Text(widget.title),
          bottom: PreferredSize(
            child: isLoad
                ? new LinearProgressIndicator()
                : Divider(height: 1.0, color: ThemeUtils.currentColorTheme),
            preferredSize: const Size.fromHeight(1.0),
          ),
        ),
        withJavascript: true,
        withZoom: false,
        withLocalStorage: true,
      ),
      onWillPop: () {
        Navigator.of(context).pop();
      },
    );
  }
}
