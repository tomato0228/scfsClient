import 'package:azlistview/azlistview.dart';

class UserEntity {
  int total;
  UserData data;
  String message;
  int status;

  UserEntity({this.total, this.data, this.message, this.status});

  UserEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class ContactsEntity {
  int total;
  List<UserData> data;
  String message;
  int status;

  ContactsEntity({this.total, this.data, this.message, this.status});

  ContactsEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['data'] != null) {
      data = new List<UserData>();
      (json['data'] as List).forEach((v) {
        data.add(new UserData.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class UserData extends ISuspensionBean {
  String userSignature;
  String userSex;
  String userPassword;
  String userAddr;
  String userEmail;
  String userTel;
  String userBirth;
  String userType;
  String userName;
  int userId;
  String userProfile;
  String userDate;
  String tagIndex;
  String namePinyin;

  UserData({
    this.userSignature = '',
    this.userSex = '',
    this.userPassword = '',
    this.userAddr = '',
    this.userEmail = '',
    this.userTel = '',
    this.userBirth,
    this.userType = '',
    this.userName = '',
    this.userId = 0,
    this.userProfile = '',
    this.userDate,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    userSignature = json['userSignature'];
    userSex = json['userSex'];
    userPassword = json['userPassword'];
    userAddr = json['userAddr'];
    userEmail = json['userEmail'];
    userTel = json['userTel'];
    userBirth = json['userBirth'];
    userType = json['userType'];
    userName = json['userName'];
    userId = json['userId'];
    userProfile = json['userProfile'];
    userDate = json['userDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userSignature'] = this.userSignature;
    data['userSex'] = this.userSex;
    data['userPassword'] = this.userPassword;
    data['userAddr'] = this.userAddr;
    data['userEmail'] = this.userEmail;
    data['userTel'] = this.userTel;
    data['userBirth'] = this.userBirth;
    data['userType'] = this.userType;
    data['userName'] = this.userName;
    data['userId'] = this.userId;
    data['userProfile'] = this.userProfile;
    data['userDate'] = this.userDate;
    data['tagIndex'] = tagIndex;
    data['namePinyin'] = namePinyin;
    data['isShowSuspension'] = isShowSuspension;
    return data;
  }

  @override
  String getSuspensionTag() => tagIndex;
}
