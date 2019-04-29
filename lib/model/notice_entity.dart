class NoticeEntity {
  int total;
  List<NoticeData> data;
  String message;
  int status;

  NoticeEntity({this.total, this.data, this.message, this.status});

  NoticeEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['data'] != null) {
      data = new List<NoticeData>();
      (json['data'] as List).forEach((v) {
        data.add(new NoticeData.fromJson(v));
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

class NoticeData {
  String userSignature;
  String userSex;
  String userAddr;
  String className;
  String userTel;
  String userName;
  int userId;
  int noticeId;
  String noticeTitle;
  String userProfile;
  String noticeContent;
  int classId;
  String noticeDate;
  String userEmail;
  String userType;
  String noticeAttachment;

  NoticeData(
      {this.userSignature,
      this.userSex,
      this.userAddr,
      this.className,
      this.userTel,
      this.userName,
      this.userId,
      this.noticeId,
      this.noticeTitle,
      this.userProfile,
      this.noticeContent,
      this.classId,
      this.noticeDate,
      this.userEmail,
      this.userType,
      this.noticeAttachment});

  NoticeData.fromJson(Map<String, dynamic> json) {
    userSignature = json['userSignature'];
    userSex = json['userSex'];
    userAddr = json['userAddr'];
    className = json['className'];
    userTel = json['userTel'];
    userName = json['userName'];
    userId = json['userId'];
    noticeId = json['noticeId'];
    noticeTitle = json['noticeTitle'];
    userProfile = json['userProfile'];
    noticeContent = json['noticeContent'];
    classId = json['classId'];
    noticeDate = json['noticeDate'];
    userEmail = json['userEmail'];
    userType = json['userType'];
    noticeAttachment = json['noticeAttachment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userSignature'] = this.userSignature;
    data['userSex'] = this.userSex;
    data['userAddr'] = this.userAddr;
    data['className'] = this.className;
    data['userTel'] = this.userTel;
    data['userName'] = this.userName;
    data['userId'] = this.userId;
    data['noticeId'] = this.noticeId;
    data['noticeTitle'] = this.noticeTitle;
    data['userProfile'] = this.userProfile;
    data['noticeContent'] = this.noticeContent;
    data['classId'] = this.classId;
    data['noticeDate'] = this.noticeDate;
    data['userEmail'] = this.userEmail;
    data['userType'] = this.userType;
    data['noticeAttachment'] = this.noticeAttachment;
    return data;
  }
}
