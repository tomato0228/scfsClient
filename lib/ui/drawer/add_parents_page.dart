import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/util/theme_util.dart';

class AddParentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddParentsPageState();
  }
}

class AddParentsPageState extends State<AddParentsPage> {
  TextEditingController editingController;
  FocusNode focusNode = new FocusNode();
  List<Widget> actions = new List();

  UserData userData;
  List<UserData> _contacts = List();

  int _suspensionHeight = 40;
  int _itemHeight = 60;

  @override
  void initState() {
    super.initState();
    userData = User.singleton.userData;
    editingController = new TextEditingController();
    editingController.addListener(() {
      if (editingController.text == null || editingController.text == "") {
        setState(() {
          actions = [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
            )
          ];
        });
      } else {
        setState(() {
          actions = [
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  editingController.clear();
                  changeContent();
                }),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                changeContent();
              },
            )
          ];
        });
      }
    });
  }

  Future<Null> _getData() async {
    ApiService().searchUser((ContactsEntity _contactsEntity) {
      if (_contactsEntity != null && _contactsEntity.status == 0) {
        _contacts = _contactsEntity.data;
        _handleList();
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: "搜索家长失败，请重试！");
      }
    }, (Error error) {
      Fluttertoast.showToast(msg: "搜索家长错误，请检查网络！");
    }, userData.userId, editingController.text.trim(), true);
  }

  void changeContent() {
    focusNode.unfocus();
    setState(() {});
    if (editingController.text == null || editingController.text == "") {
    } else {
      _getData();
    }
  }

  void _handleList() {
    List<UserData> list = _contacts;
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].userName);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(list);
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipOval(
              child: Image.network(
            userData.userSignature,
            width: 80.0,
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              userData.userName,
              textScaleFactor: 1.2,
            ),
          ),
          Text(userData.userTel),
        ],
      ),
    );
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: _suspensionHeight.toDouble(),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Text(
            '$susTag',
            textScaleFactor: 1.2,
          ),
          Expanded(
              child: Divider(
            height: .0,
            indent: 10.0,
          ))
        ],
      ),
    );
  }

  Widget _buildListItem(UserData model) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          width: MediaQuery.of(context).size.width - 52,
          child: ListTile(
            leading: model.userSignature == ''
                ? CircleAvatar(child: Text(model.userName[0]))
                : CircleAvatar(
                    backgroundImage: NetworkImage(model.userSignature),
                    backgroundColor: Color(0xffff0000),
                    radius: 24.0,
                  ),
            title: Text(model.userName, style: TextStyle(fontSize: 18.0)),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.phone,
                    color: Colors.black.withOpacity(0.6), size: 16.0),
                SizedBox(width: 5.0),
                Text(model.userTel),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _openAlertDialog(model.userId, model.userName);
              },
              color: ThemeUtils.currentColorTheme,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextField searchField = new TextField(
      autofocus: true,
      style: TextStyle(color: Colors.white),
      decoration: new InputDecoration(
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          hintText: "搜索更多干货"),
      focusNode: focusNode,
      controller: editingController,
    );

    return Scaffold(
      appBar: AppBar(
        title: searchField,
        actions: actions,
      ),
      body: AzListView(
        data: _contacts,
        itemBuilder: (context, model) => _buildListItem(model),
        isUseRealIndex: true,
        itemHeight: _itemHeight,
        suspensionHeight: _suspensionHeight,
        header: AzListViewHeader(
            height: 180,
            builder: (context) {
              return _buildHeader();
            }),
        indexBarBuilder: (BuildContext context, List<String> tags,
            IndexBarTouchCallback onTouch) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey[300], width: .5)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: IndexBar(
                data: tags,
                itemHeight: 20,
                onTouch: (details) {
                  onTouch(details);
                },
              ),
            ),
          );
        },
        indexHintBuilder: (context, hint) {
          return Container(
            alignment: Alignment.center,
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.blue[700].withAlpha(200),
              shape: BoxShape.circle,
            ),
            child: Text(hint,
                style: TextStyle(color: Colors.white, fontSize: 30.0)),
          );
        },
      ),
    );
  }

  Future _openAlertDialog(int parentsId, String parentsName) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(S.of(context).tip),
          content: Text(S.of(context).addParentsTip(parentsName)),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text(S.of(context).cancel,
                  style: TextStyle(color: Colors.orange)),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openSimpleDialog(parentsId, parentsName);
              },
              child: new Text(S.of(context).ok,
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  Future _openSimpleDialog(int parentsId, String parentsName) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            S.of(context).selectParentsRelation(parentsName),
            textAlign: TextAlign.center,
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(
                S.of(context).fatherRelations,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _addParents(parentsId, '父亲');
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text(
                S.of(context).motherRelations,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _addParents(parentsId, '其他');
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text(
                S.of(context).grandpaRelations,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _addParents(parentsId, '爷爷');
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text(
                S.of(context).grandmaRelations,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _addParents(parentsId, '奶奶');
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text(
                S.of(context).otherRelations,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                _addParents(parentsId, '其他');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// 添加家长
  Future<Null> _addParents(int parentsId, String parentsRelation) async {
    ApiService().addParents((BaseEntity _baseEntity) {
      if (_baseEntity != null && _baseEntity.status == 0) {
        Fluttertoast.showToast(msg: "添加家长成功！");
      } else {
        Fluttertoast.showToast(msg: "添加家长失败，请重试！");
      }
    }, (Error error) {
      Fluttertoast.showToast(msg: "添加家长错误，请检查网络！");
    }, userData.userId, parentsId, parentsRelation);
  }
}
