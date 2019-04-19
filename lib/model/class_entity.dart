class ClassEntity {
	int total;
	List<ClassData> data;
	String message;
	int status;

	ClassEntity({this.total, this.data, this.message, this.status});

	ClassEntity.fromJson(Map<String, dynamic> json) {
		total = json['total'];
		if (json['data'] != null) {
			data = new List<ClassData>();
			(json['data'] as List).forEach((v) { data.add(new ClassData.fromJson(v)); });
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

class ClassData {
	int studentId;
	int classId;
	int gradeId;
	int majorId;
	int teacherId;
	String className;

	ClassData({this.studentId, this.classId, this.gradeId, this.majorId, this.teacherId, this.className});

	ClassData.fromJson(Map<String, dynamic> json) {
		studentId = json['studentId'];
		classId = json['classId'];
		gradeId = json['gradeId'];
		majorId = json['majorId'];
		teacherId = json['teacherId'];
		className = json['className'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['studentId'] = this.studentId;
		data['classId'] = this.classId;
		data['gradeId'] = this.gradeId;
		data['majorId'] = this.majorId;
		data['teacherId'] = this.teacherId;
		data['className'] = this.className;
		return data;
	}
}
