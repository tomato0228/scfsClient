import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tomato_scfs/base/_base_widget.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/generated/i18n.dart';
import 'package:tomato_scfs/http/api_service.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/chat_contacts_entity.dart';
import 'package:tomato_scfs/model/chat_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';
import 'package:tomato_scfs/ui/app.dart';
import 'package:tomato_scfs/ui/drawer/about_page.dart';
import 'package:tomato_scfs/ui/drawer/personal_page.dart';
import 'package:tomato_scfs/util/const.dart';
import 'package:tomato_scfs/util/utils.dart';

class ChatPage extends BaseWidget {
  final ChatContactsData chatContactsData;

  ChatPage({@required this.chatContactsData});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return ChatPageState(chatContactsData: chatContactsData);
  }
}

class ChatPageState extends BaseWidgetState<ChatPage> {
  UserData userData;
  final ChatContactsData chatContactsData;
  ScrollController _scrollController = new ScrollController();
  bool isLoading;
  List<ChatData> chatDatas;
  bool isGet;

  var listMessage;
  File imageFile;
  bool isShowSticker;
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  ChatPageState({@required this.chatContactsData});

  @override
  void initState() {
    super.initState();
    setAppBarVisible(true);
    isGet = true;
    isLoading = false;
    isShowSticker = false;
    userData = User.singleton.userData;
    _getChat(1);
    var timerObservable = Observable.periodic(Duration(seconds: 2), (value) {
      if (mounted) {
        _getChat(0);
      }
    });
    timerObservable.listen(null);
  }

  @override
  Widget getContentWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // List of messages
            buildListMessage(),
            // Sticker
            (isShowSticker ? buildSticker() : Container()),
            // Input content
            buildInput(),
          ],
        ),
        // Loading
        buildLoading()
      ],
    );
  }

  Future<Null> _getChat(_chatMesg) async {
    if (!isGet) return;
    if (userData != null && chatContactsData != null) {
      ApiService().getChatList((ChatEntity _chatEntity) {
        if (_chatEntity != null && _chatEntity.status == 0) {
          if (_chatMesg == 1) {
            chatDatas = _chatEntity.data;
            if (chatDatas == null) {
              chatDatas = [];
            }
          } else {
            if (_chatEntity.total > 0) {
              chatDatas.insertAll(0, _chatEntity.data);
            }
          }
          _updateChatByUser();
          setState(() {});
        } else {
          Fluttertoast.showToast(msg: S.of(context).failedAgain);
//          Fluttertoast.showToast(msg: "获取消息列表失败！");
        }
      }, (Error error) {
        showError();
      }, userData.userId, chatContactsData.userId, _chatMesg);
    }
  }

  Future<Null> _getChatOne(chatId) async {
    ApiService().getChat((ChatOneEntity _chatOneEntity) {
      if (_chatOneEntity != null &&
          _chatOneEntity.status == 0 &&
          _chatOneEntity.total == 1) {
        setState(() {
          chatDatas.insert(0, _chatOneEntity.data);
        });
      }
    }, (Error error) {
      setState(() {
        showError();
      });
    }, chatId);
  }

  Future<Null> _addChat(_chatContent, _chatType) async {
    if (userData != null && chatContactsData != null) {
      ApiService().addChat((BaseEntity _baseEntity) {
        if (_baseEntity != null && _baseEntity.status == 0) {
          _getChatOne(_baseEntity.data);
        } else {
          Fluttertoast.showToast(msg: S.of(context).failedAgain);
//          Fluttertoast.showToast(msg: "发送消息失败！");
        }
      }, (Error error) {
        setState(() {
          showError();
        });
      }, userData.userId, chatContactsData.userId, _chatType, _chatContent);
    }
  }

  Future<Null> _updateChatByUser() async {
    ApiService().updateChatByUser((BaseEntity _baseEntity) {
      if (_baseEntity != null && _baseEntity.status == 0) {
        /// Nothing
      } else {
        Fluttertoast.showToast(msg: S.of(context).failedAgain);
      }
    }, (Error error) {
      setState(() {
        showError();
      });
    }, chatContactsData.userId, userData.userId);
  }

  void onSendMessage(String content, int type) {
    /// type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
      _addChat(content, type);
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 2000), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: S.of(context).nothingSend);
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = image;
//        isLoading = true;
      });
    }
    //uploadFile();
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Widget buildItem(int index, ChatData chatData) {
    if (chatData.sendId == userData.userId) {
      /// 我发送的
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
//                chatData.chatMesg == 0
//                    ? Container(
//                        child: Text(
//                          '未读',
//                          style: TextStyle(color: primaryColor, fontSize: 12.0),
//                        ),
//                        margin: EdgeInsets.only(right: 5.0),
//                      )
//                    : Container(),
                chatData.chatType == 0
                    // Text
                    ? LimitedBox(
                        maxWidth: MediaQuery.of(context).size.width * 0.65,
                        child: Container(
                          child: Text(
                            chatData.chatContent,
                            style: TextStyle(color: primaryColor),
                          ),
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          decoration: BoxDecoration(
                              color: greyColor2,
                              borderRadius: BorderRadius.circular(8.0)),
                          margin: EdgeInsets.only(right: 10.0),
                        ),
                      )
                    : chatData.chatType == 1
                        // Image
                        ? Container(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                themeColor),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(70.0),
                                      decoration: BoxDecoration(
                                        color: greyColor2,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Material(
                                      child: Image.asset(
                                        Utils.getImgPath('img_not_available',
                                            format: 'jpeg'),
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                imageUrl: chatData.chatContent,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            margin: EdgeInsets.only(
                              bottom: 5.0,
                              right: 5.0,
                              top: 10,
                            ),
                          )
                        // Sticker
                        : Container(
                            child: Image.asset(
                              Utils.getImgPath(chatData.chatContent,
                                  format: 'gif'),
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                              bottom: 5.0,
                              right: 5.0,
                              top: 10,
                            ),
                          ),
                Material(
                  child: InkWell(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                      imageUrl: userData.userSignature,
                      width: 35.0,
                      height: 35.0,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return AboutPage();
                      }));
                    },
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            // Time
            isLastMessageRight(index)
                ? Container(
                    child: Text(
                      Utils.formatDateToFriendly(chatData.chatDate),
                      style: TextStyle(
                          color: greyColor,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(right: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Material(
                  child: InkWell(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                      imageUrl: chatContactsData.userSignature,
                      width: 35.0,
                      height: 35.0,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return PersonalPage(
                          userData:
                              UserData.fromJson(chatContactsData.toJson()),
                          isShowFB: false,
                        );
                      }));
                    },
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
                chatData.chatType == 0
                    ? LimitedBox(
                        maxWidth: MediaQuery.of(context).size.width * 0.65,
                        child: Container(
                          child: Text(
                            chatData.chatContent,
                            style: TextStyle(color: Colors.white),
                          ),
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          margin: EdgeInsets.only(left: 10.0),
                        ),
                      )
                    : chatData.chatType == 1
                        ? Container(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                themeColor),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(70.0),
                                      decoration: BoxDecoration(
                                        color: greyColor2,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Material(
                                      child: Image.asset(
                                        Utils.getImgPath('img_not_available',
                                            format: 'jpeg'),
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                imageUrl: chatData.chatContent,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            margin: EdgeInsets.only(
                              bottom: 5,
                              left: 10.0,
                              top: 5,
                            ),
                          )
                        : Container(
                            child: Image.asset(
                              Utils.getImgPath(chatData.chatContent,
                                  format: 'gif'),
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                              bottom: 5,
                              left: 10.0,
                              top: 5,
                            ),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      Utils.formatDateToFriendly(chatData.chatDate),
                      style: TextStyle(
                          color: greyColor,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            chatDatas != null &&
            chatDatas[index - 1].sendId == userData.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            chatDatas != null &&
            chatDatas[index - 1].sendId == chatContactsData.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: Image.asset(
                  Utils.getImgPath('mimi1', format: 'gif'),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: Image.asset(
                  Utils.getImgPath('mimi2', format: 'gif'),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: Image.asset(
                  Utils.getImgPath('mimi3', format: 'gif'),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: Image.asset(
                  Utils.getImgPath('mimi4', format: 'gif'),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: Image.asset(
                  Utils.getImgPath('mimi5', format: 'gif'),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: Image.asset(
                  Utils.getImgPath('mimi6', format: 'gif'),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: Image.asset(
                  Utils.getImgPath('mimi7', format: 'gif'),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: Image.asset(
                  Utils.getImgPath('mimi8', format: 'gif'),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: Image.asset(
                  Utils.getImgPath('mimi9', format: 'gif'),
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: S.of(context).inputMessage,
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: textEditingController.text.trimLeft() == ''
                    ? null
                    : (() => onSendMessage(textEditingController.text, 0)),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
        color: Colors.white,
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: chatDatas == null // || chatDatas.length == 0
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, chatDatas[index]),
              itemCount: chatDatas.length,
              reverse: true,
              controller: listScrollController,
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
      title: Text(chatContactsData.userName,
          style: TextStyle(fontWeight: FontWeight.bold)),
      elevation: 1.0,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return PersonalPage(
                  userData: UserData.fromJson(chatContactsData.toJson()),
                  isShowFB: false,
                );
              }));
            })
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
    isGet = false;
  }
}
