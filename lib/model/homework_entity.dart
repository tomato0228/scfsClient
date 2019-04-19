class HomeworkEntity {
  int total;
  List<HomeworkData> data;
  String message;
  int status;

  HomeworkEntity({this.total, this.data, this.message, this.status});

  HomeworkEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['data'] != null) {
      data = new List<HomeworkData>();
      (json['data'] as List).forEach((v) {
        data.add(new HomeworkData.fromJson(v));
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

class HomeworkData {
  String userSignature;
  String userSex;
  String userAddr;
  String userTel;
  String userBirth;
  String userName;
  String userProfile;
  int classId;
  String courseName;
  String homeworkContent;
  int homeworkId;
  int teacherId;
  int tclassId;
  String tclassValidation;
  String homeworkAttachment;
  String userEmail;
  String homeworkDate;
  int courseId;

  HomeworkData({
    this.userSignature = '',
    this.userSex = '',
    this.userAddr = '',
    this.userTel = '',
    this.userBirth,
    this.userName = '',
    this.userProfile = '',
    this.classId = 0,
    this.courseName = '',
    this.homeworkContent = '',
    this.homeworkId = 0,
    this.teacherId = 0,
    this.tclassId = 0,
    this.tclassValidation = '',
    this.homeworkAttachment = '',
    this.userEmail = '',
    this.homeworkDate,
    this.courseId = 0,
  });

  HomeworkData.fromJson(Map<String, dynamic> json) {
    userSignature = json['userSignature'];
    userSex = json['userSex'];
    userAddr = json['userAddr'];
    userTel = json['userTel'];
    userBirth = json['userBirth'];
    userName = json['userName'];
    userProfile = json['userProfile'];
    classId = json['classId'];
    courseName = json['courseName'];
    homeworkContent = json['homeworkContent'];
    homeworkId = json['homeworkId'];
    teacherId = json['teacherId'];
    tclassId = json['tclassId'];
    tclassValidation = json['tclassValidation'];
    homeworkAttachment = json['homeworkAttachment'];
    userEmail = json['userEmail'];
    homeworkDate = json['homeworkDate'];
    courseId = json['courseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userSignature'] = this.userSignature;
    data['userSex'] = this.userSex;
    data['userAddr'] = this.userAddr;
    data['userTel'] = this.userTel;
    data['userBirth'] = this.userBirth;
    data['userName'] = this.userName;
    data['userProfile'] = this.userProfile;
    data['classId'] = this.classId;
    data['courseName'] = this.courseName;
    data['homeworkContent'] = this.homeworkContent;
    data['homeworkId'] = this.homeworkId;
    data['teacherId'] = this.teacherId;
    data['tclassId'] = this.tclassId;
    data['tclassValidation'] = this.tclassValidation;
    data['homeworkAttachment'] = this.homeworkAttachment;
    data['userEmail'] = this.userEmail;
    data['homeworkDate'] = this.homeworkDate;
    data['courseId'] = this.courseId;
    return data;
  }
}
