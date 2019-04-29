import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tomato_scfs/base/_base_widget.dart';
import 'package:tomato_scfs/common/application.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/event/change_badgeno_event.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/chat_contacts_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/app.dart';
import 'package:tomato_scfs/ui/chat/chat_page.dart';
import 'package:tomato_scfs/util/const.dart';
import 'package:tomato_scfs/util/utils.dart';

class ChatContactsPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    return ChatContactsPageState();
  }
}

class ChatContactsPageState extends BaseWidgetState<ChatContactsPage> {
  UserData userData;
  List<ChatContactsData> _chatContactsDatas;
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;
  int badgeNo = 0;

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    userData = User.singleton.userData;
    _getChatContacts();
    var timerObservable = Observable.periodic(Duration(seconds: 3), (value) {
      if (mounted) {
        _getChatContacts();
      }
    });
    timerObservable.listen(null);
  }

  @override
  Widget getContentWidget(BuildContext context) {
    return Scaffold(
      body: Container(
        child: (_chatContactsDatas == null)
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              )
            : RefreshIndicator(
                color: Colors.deepOrangeAccent,
                backgroundColor: Colors.white,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  itemBuilder: (context, index) =>
                      buildItem(context, _chatContactsDatas[index]),
                  itemCount: _chatContactsDatas.length,
                ),
                onRefresh: _onRefresh,
              ),
      ),
    );
  }

  @override
  void onClickErrorWidget() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => App()), (_) => false);
  }

  @override
  AppBar getAppBar() {
    return AppBar(
      title: Text("ChatContacts"),
      elevation: 0.0,
    );
  }

  Widget buildItem(BuildContext context, ChatContactsData chatContactsData) {
    return ListTile(
      leading: chatContactsData.userSignature == ''
          ? CircleAvatar(child: Text(chatContactsData.userName[0]))
          : CircleAvatar(
              backgroundImage: NetworkImage(chatContactsData.userSignature),
              backgroundColor: Color(0xffff0000),
              radius: 24.0,
            ),
      title: Text(chatContactsData.userName, style: TextStyle(fontSize: 18.0)),
      subtitle: Text(
        chatContactsData.chatContent,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            Utils.formatDateToFriendly(chatContactsData.chatDate),
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 12.0,
            ),
          ),
          chatContactsData.chatMesgnum != 0
              ? Container(
                  width: chatContactsData.chatMesgnum > 100 ? 32 : 24,
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                  margin: EdgeInsets.only(top: 5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    chatContactsData.chatMesgnum > 100
                        ? '99+'
                        : chatContactsData.chatMesgnum.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                )
              : Text(''),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ChatPage(chatContactsData: chatContactsData);
        }));
      },
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      _getChatContacts();
    });
  }

  Future<Null> _getChatContacts() async {
    if (userData != null) {
      ApiService().getChatContacts((ChatContactsEntity _chatContactsEntity) {
        if (_chatContactsEntity != null && _chatContactsEntity.status == 0) {
          setState(() {
            _chatContactsDatas = _chatContactsEntity.data;
          });
          if (_chatContactsDatas == null) _chatContactsDatas = [];
          int t = 0;
          _chatContactsDatas.forEach((c) => t += c.chatMesgnum);
          if (t != badgeNo) {
            badgeNo = t;
            Application.eventBus.fire(new ChangeBadeNoEvent(badgeNo));
          }
        } else {
          Fluttertoast.showToast(msg: S.of(context).failedAgain);
//          Fluttertoast.showToast(msg: "获取联系人列表失败！");
        }
      }, (Error error) {
        setState(() {
          showError();
        });
      }, userData.userId);
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }
}
