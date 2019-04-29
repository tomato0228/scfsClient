class TestEntity {
  int total;
  List<TestData> data;
  String message;
  int status;

  TestEntity({this.total, this.data, this.message, this.status});

  TestEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['data'] != null) {
      data = new List<TestData>();
      (json['data'] as List).forEach((v) {
        data.add(new TestData.fromJson(v));
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

class TestData {
  String userSignature;
  String userSex;
  String chatDate;
  int chatId;
  int otherId;
  String userAddr;
  String userTel;
  String userBirth;
  String chatContent;
  String userName;
  int chatMesg;
  int userId;
  String userProfile;
  int chatMesgnum;
  String userEmail;
  String userType;
  int chatType;

  TestData(
      {this.userSignature,
      this.userSex,
      this.chatDate,
      this.chatId,
      this.otherId,
      this.userAddr,
      this.userTel,
      this.userBirth,
      this.chatContent,
      this.userName,
      this.chatMesg,
      this.userId,
      this.userProfile,
      this.chatMesgnum,
      this.userEmail,
      this.userType,
      this.chatType});

  TestData.fromJson(Map<String, dynamic> json) {
    userSignature = json['userSignature'];
    userSex = json['userSex'];
    chatDate = json['chatDate'];
    chatId = json['chatId'];
    otherId = json['otherId'];
    userAddr = json['userAddr'];
    userTel = json['userTel'];
    userBirth = json['userBirth'];
    chatContent = json['chatContent'];
    userName = json['userName'];
    chatMesg = json['chatMesg'];
    userId = json['userId'];
    userProfile = json['userProfile'];
    chatMesgnum = json['chatMesgnum'];
    userEmail = json['userEmail'];
    userType = json['userType'];
    chatType = json['chatType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userSignature'] = this.userSignature;
    data['userSex'] = this.userSex;
    data['chatDate'] = this.chatDate;
    data['chatId'] = this.chatId;
    data['otherId'] = this.otherId;
    data['userAddr'] = this.userAddr;
    data['userTel'] = this.userTel;
    data['userBirth'] = this.userBirth;
    data['chatContent'] = this.chatContent;
    data['userName'] = this.userName;
    data['chatMesg'] = this.chatMesg;
    data['userId'] = this.userId;
    data['userProfile'] = this.userProfile;
    data['chatMesgnum'] = this.chatMesgnum;
    data['userEmail'] = this.userEmail;
    data['userType'] = this.userType;
    data['chatType'] = this.chatType;
    return data;
  }
}
