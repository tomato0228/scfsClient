class ChatContactsEntity {
	int total;
	List<ChatContactsData> data;
	String message;
	int status;

	ChatContactsEntity({this.total, this.data, this.message, this.status});

	ChatContactsEntity.fromJson(Map<String, dynamic> json) {
		total = json['total'];
		if (json['data'] != null) {
			data = new List<ChatContactsData>();
			(json['data'] as List).forEach((v) { data.add(new ChatContactsData.fromJson(v)); });
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

class ChatContactsData {
	String userSignature;
	String chatDate;
	int chatId;
	int otherId;
	String userTel;
	String chatContent;
	String userName;
	int chatMesg;
	int userId;
	int chatMesgnum;
	String userEmail;
	String userType;
	int chatType;

	ChatContactsData({this.userSignature, this.chatDate, this.chatId, this.otherId, this.userTel, this.chatContent, this.userName, this.chatMesg, this.userId, this.chatMesgnum, this.userEmail, this.userType, this.chatType});

	ChatContactsData.fromJson(Map<String, dynamic> json) {
		userSignature = json['userSignature'];
		chatDate = json['chatDate'];
		chatId = json['chatId'];
		otherId = json['otherId'];
		userTel = json['userTel'];
		chatContent = json['chatContent'];
		userName = json['userName'];
		chatMesg = json['chatMesg'];
		userId = json['userId'];
		chatMesgnum = json['chatMesgnum'];
		userEmail = json['userEmail'];
		userType = json['userType'];
		chatType = json['chatType'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['userSignature'] = this.userSignature;
		data['chatDate'] = this.chatDate;
		data['chatId'] = this.chatId;
		data['otherId'] = this.otherId;
		data['userTel'] = this.userTel;
		data['chatContent'] = this.chatContent;
		data['userName'] = this.userName;
		data['chatMesg'] = this.chatMesg;
		data['userId'] = this.userId;
		data['chatMesgnum'] = this.chatMesgnum;
		data['userEmail'] = this.userEmail;
		data['userType'] = this.userType;
		data['chatType'] = this.chatType;
		return data;
	}
}
