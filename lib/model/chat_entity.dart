class ChatEntity {
  int total;
  List<ChatData> data;
  String message;
  int status;

  ChatEntity({this.total, this.data, this.message, this.status});

  ChatEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['data'] != null) {
      data = new List<ChatData>();
      (json['data'] as List).forEach((v) {
        data.add(new ChatData.fromJson(v));
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

class ChatOneEntity {
  int total;
  ChatData data;
  String message;
  int status;

  ChatOneEntity({this.total, this.data, this.message, this.status});

  ChatOneEntity.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    data = json['data'] != null ? new ChatData.fromJson(json['data']) : null;
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

class ChatData {
  String chatDate;
  int sendId;
  int chatId;
  String chatContent;
  int chatMesg;
  int chatType;
  int receiveId;

  ChatData(
      {this.chatDate,
      this.sendId,
      this.chatId,
      this.chatContent,
      this.chatMesg,
      this.chatType,
      this.receiveId});

  ChatData.fromJson(Map<String, dynamic> json) {
    chatDate = json['chatDate'];
    sendId = json['sendId'];
    chatId = json['chatId'];
    chatContent = json['chatContent'];
    chatMesg = json['chatMesg'];
    chatType = json['chatType'];
    receiveId = json['receiveId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatDate'] = this.chatDate;
    data['sendId'] = this.sendId;
    data['chatId'] = this.chatId;
    data['chatContent'] = this.chatContent;
    data['chatMesg'] = this.chatMesg;
    data['chatType'] = this.chatType;
    data['receiveId'] = this.receiveId;
    return data;
  }
}
