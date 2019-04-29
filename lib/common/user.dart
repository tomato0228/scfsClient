import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_scfs/model/user_entity.dart';

class User {
  static final User singleton = User._internal();

  factory User() {
    return singleton;
  }

  User._internal();

  List<String> cookie;
  UserData userData;

  void saveUserInfo(UserEntity _userEntity, Response response) {
    List<String> cookies = response.headers["set-cookie"];
    cookie = cookies;
    userData = _userEntity.data;
    saveInfo();
  }

  Future<Null> getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<String> cookies = sp.getStringList("cookies");
    if (cookies != null) {
      cookie = cookies;
    }

    if (sp.getString("userData") != null) {
      UserData userData1 =
          UserData.fromJson(json.decode(sp.getString("userData")));
      if (userData1 != null) {
        userData = userData1;
      }
    }
  }

  saveInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList("cookies", cookie);
    sp.setString("userData", json.encode(userData));
  }

  void clearUserInfo() {
    cookie = null;
    userData = null;
    clearInfo();
  }

  clearInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList("cookies", null);
    sp.setString("userData", null);
  }
}
