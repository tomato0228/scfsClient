import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/base/_base_widget.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/school_entity.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class SchoolPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return SchoolPageState();
  }
}

class SchoolPageState extends BaseWidgetState<SchoolPage> {
  ScrollController _scrollController = ScrollController();
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  SchoolData _schoolData = new SchoolData();

  Future<Null> _getSchool() async {
    int userId = User.singleton.userData.userId;
    ApiService().getSchool((SchoolEntity _schoolEntity) {
      if (_schoolEntity != null && _schoolEntity.status == 0) {
        setState(() {
          _schoolData = _schoolEntity.data[0];
        });
        showContent();
      } else {
        showEmpty();
        Fluttertoast.showToast(msg: "获取学校信息失败！");
      }
    }, (DioError error) {
      print(error.response);
      setState(() {
        showError();
      });
    }, userId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAppBarVisible(true);
    showloading();
    _getSchool();
    _scrollController.addListener(() {
      _scrollController.addListener(() {
        //当前位置是否超过屏幕高度
        if (_scrollController.offset < 200 && showToTopBtn) {
          setState(() {
            showToTopBtn = false;
          });
        } else if (_scrollController.offset >= 200 && showToTopBtn == false) {
          setState(() {
            showToTopBtn = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  AppBar getAppBar() {
    // TODO: implement getAppBar
    return AppBar(
      title: Text(_schoolData.schoolName),
      elevation: 0.0,
    );
  }

  @override
  Widget getContentWidget(BuildContext context) {
    // TODO: implement getContentWidget
    return Scaffold(
      body: new SingleChildScrollView(
        child: new ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 120.0,
          ),
          child: Card(
            child: Column(
              children: <Widget>[
                Container(
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                      child: Image.network(
                        _schoolData.schoolLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(_schoolData.schoolLogo),
                  ),
                  title: Text(_schoolData.schoolName),
                  subtitle: Text(_schoolData.schoolAddr),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    _schoolData.schoolProfile,
                    //maxLines: 2,
                    //overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: ThemeUtils.currentColorTheme,
      ),
//      floatingActionButton: !showToTopBtn
//          ? null
//          : FloatingActionButton(
//              child: Icon(Icons.arrow_upward),
//              backgroundColor: ThemeUtils.currentColorTheme,
//              onPressed: () {
//                //返回到顶部时执行动画
//                _scrollController.animateTo(
//                  .0,
//                  duration: Duration(milliseconds: 200),
//                  curve: Curves.ease,
//                );
//              }),
    );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
    showloading();
    _getSchool();
  }
}
