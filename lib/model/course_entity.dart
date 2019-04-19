class CourseEntity {
	int total;
	List<CourseData> data;
	String message;
	int status;

	CourseEntity({this.total, this.data, this.message, this.status});

	CourseEntity.fromJson(Map<String, dynamic> json) {
		total = json['total'];
		if (json['data'] != null) {
			data = new List<CourseData>();
			(json['data'] as List).forEach((v) { data.add(new CourseData.fromJson(v)); });
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

class CourseData {
	String courseName;
	int collegeId;
	int courseId;

	CourseData({this.courseName, this.collegeId, this.courseId});

	CourseData.fromJson(Map<String, dynamic> json) {
		courseName = json['courseName'];
		collegeId = json['collegeId'];
		courseId = json['courseId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['courseName'] = this.courseName;
		data['collegeId'] = this.collegeId;
		data['courseId'] = this.courseId;
		return data;
	}
}
