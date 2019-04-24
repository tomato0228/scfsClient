import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tomato_scfs/base/_base_widget.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/chat_contacts_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/chat/chat_page.dart';
import 'package:tomato_scfs/util/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomato_scfs/util/utils.dart';

class ChatContactsPage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> getState() {
    // TODO: implement getState
    return ChatContactsPageState();
  }
}

class ChatContactsPageState extends BaseWidgetState<ChatContactsPage> {
  UserData userData;
  List<ChatContactsData> _chatContactsDatas;
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
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
      body: Stack(
        children: <Widget>[
          Container(
            child:
                (_chatContactsDatas == null || _chatContactsDatas.length == 0)
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                      )
                    : RefreshIndicator(
                        color: Colors.deepOrangeAccent,
                        backgroundColor: Colors.white,
                        child: ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemBuilder: (context, index) =>
                              buildItem(context, _chatContactsDatas[index]),
                          itemCount: _chatContactsDatas.length,
                        ),
                        onRefresh: _onRefresh,
                      ),
          ),
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    ),
                    color: Colors.transparent,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
    showloading();
  }

  @override
  AppBar getAppBar() {
    // TODO: implement getAppBar
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
              ? Chip(
                  label: Text(chatContactsData.chatMesgnum.toString()),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: Colors.lightBlue,
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
        } else {
          Fluttertoast.showToast(msg: "获取联系人列表失败！");
        }
      }, (DioError error) {
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
