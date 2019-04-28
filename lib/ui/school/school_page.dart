import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/base/_base_widget.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/school_entity.dart';
import 'package:tomato_scfs/ui/app.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class SchoolPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return SchoolPageState();
  }
}

class SchoolPageState extends BaseWidgetState<SchoolPage> {
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
    }, (Error error) {
      setState(() {
        showError();
      });
    }, userId);
  }

  @override
  void initState() {
    super.initState();
    setAppBarVisible(true);
    showloading();
    _getSchool();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      title: Text(_schoolData.schoolName),
      elevation: 0.0,
    );
  }

  @override
  Widget getContentWidget(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
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
                        width: 200.0,
                        height: 200.0,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.all(70.0),
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
    );
  }

  @override
  void onClickErrorWidget() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => App()),
        (route) => route == null);
  }
}
