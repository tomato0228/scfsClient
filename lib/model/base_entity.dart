class BaseEntity {
	int total;
	int data;
	String message;
	int status;

	BaseEntity({this.total, this.data, this.message, this.status});

	BaseEntity.fromJson(Map<String, dynamic> json) {
		total = json['total'];
		data = json['data'];
		message = json['message'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['total'] = this.total;
		data['data'] = this.data;
		data['message'] = this.message;
		data['status'] = this.status;
		return data;
	}
}
