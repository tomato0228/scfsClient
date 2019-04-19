import 'dart:convert' show json;

class SchoolEntity {
  int total;
  List<SchoolData> data;
  String message;
  int status;

  SchoolEntity({this.total, this.data, this.message, this.status});

  SchoolEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['data'] != null) {
      data = new List<SchoolData>();
      (json['data'] as List).forEach((v) {
        data.add(new SchoolData.fromJson(v));
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

class SchoolData {
  String schoolProfile;
  String schoolTel;
  int schoolId;
  String schoolAddr;
  String schoolUrl;
  String schoolName;
  String schoolLogo;

  SchoolData({
    this.schoolProfile = '',
    this.schoolTel = '',
    this.schoolId = 0,
    this.schoolAddr = '',
    this.schoolUrl = '',
    this.schoolName = '',
    this.schoolLogo = 'https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1555489983&di=42cad67b738af8d3ef0bd83a0ee00f44&src=http://android-artworks.25pp.com/fs08/2018/08/31/6/2_766b650936a0100b8eda4269e7193532_con.png',
  });

  SchoolData.fromJson(Map<String, dynamic> json) {
    schoolProfile = json['schoolProfile'];
    schoolTel = json['schoolTel'];
    schoolId = json['schoolId'];
    schoolAddr = json['schoolAddr'];
    schoolUrl = json['schoolUrl'];
    schoolName = json['schoolName'];
    schoolLogo = json['schoolLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schoolProfile'] = this.schoolProfile;
    data['schoolTel'] = this.schoolTel;
    data['schoolId'] = this.schoolId;
    data['schoolAddr'] = this.schoolAddr;
    data['schoolUrl'] = this.schoolUrl;
    data['schoolName'] = this.schoolName;
    data['schoolLogo'] = this.schoolLogo;
    return data;
  }
}
