import 'package:dio/dio.dart';
import 'package:tomato_scfs/common/user.dart';
import 'package:tomato_scfs/http/dio_manager.dart';
import 'package:tomato_scfs/model/base_entity.dart';
import 'package:tomato_scfs/model/chat_contacts_entity.dart';
import 'package:tomato_scfs/model/chat_entity.dart';
import 'package:tomato_scfs/model/class_entity.dart';
import 'package:tomato_scfs/model/course_entity.dart';
import 'package:tomato_scfs/model/homework_entity.dart';
import 'package:tomato_scfs/model/notice_entity.dart';
import 'package:tomato_scfs/model/school_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';

import 'api.dart';

class ApiService {
  /// 登录
  void login(Function callback, Function errorback, String _username,
      String _password) async {
    FormData formData =
        new FormData.from({"username": _username, "password": _password});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_LOGIN),
            data: formData, options: _getOptions())
        .then((response) {
      callback(UserEntity.fromJson(response.data), response);
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 注册
  void signin(
      Function callback,
      Function errorback,
      String _userName,
      String _userPassword,
      String _userType,
      String _userSex,
      String _userBirth) async {
    FormData formData = new FormData.from({
      "userName": _userName,
      "userPassword": _userPassword,
      "userType": _userType,
      "userSex": _userSex,
      "userBirth": _userBirth,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_SIGNIN),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 用户修改手机号码
  void userUpdateTel(
    Function callback,
    Function errorback,
    int _userId,
    String _userTel,
  ) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "userTel": _userTel,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_UPDATE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(UserEntity.fromJson(response.data), response);
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 用户修改邮箱
  void userUpdateEmail(
    Function callback,
    Function errorback,
    int _userId,
    String _userEmail,
  ) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "userEmail": _userEmail,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_UPDATE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(UserEntity.fromJson(response.data), response);
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 验证手机号码或邮箱是否存在
  void verifyUserAcc(
      Function callback, Function errorback, String _userAcc) async {
    FormData formData = new FormData.from({"userAcc": _userAcc});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_VERIFY_USER_ACC),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 发送验证码
  void sendValidationCode(
    Function callback,
    Function errorback,
    int _userId,
    String _validationAcc,
  ) async {
    FormData formData =
        new FormData.from({"userId": _userId, "validationAcc": _validationAcc});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_SEND_CODE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 搜索联系人
  void searchUser(
    Function callback,
    Function errorback,
    int _userId,
    String _keywords,
    bool _addParents,
  ) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "keywords": _keywords,
      'addParents': _addParents,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_SEARCH_USER),
            data: formData, options: _getOptions())
        .then((response) {
      callback(ContactsEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 添加家长
  void addParents(
    Function callback,
    Function errorback,
    int _userId,
    int _parentsId,
    String _parentsRelation,
  ) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "parentsId": _parentsId,
      'parentsRelation': _parentsRelation,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_ADD_PARENTS),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 家长获取学生列表
  void getStudentList(
    Function callback,
    Function errorback,
    int _userId,
  ) async {
    FormData formData = new FormData.from({"userId": _userId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_STUDENT_LIST),
            data: formData, options: _getOptions())
        .then((response) {
      callback(ContactsEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取学校信息
  void getSchool(Function callback, Function errorback, int _userId) async {
    FormData formData = new FormData.from({"userId": _userId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_SCHOOL),
            data: formData, options: _getOptions())
        .then((response) {
      print(response.data);
      callback(SchoolEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取科目列表
  void getCourseByUserId(
    Function callback,
    Function errorback,
    int _userId,
  ) async {
    FormData formData = new FormData.from({"userId": _userId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_COURSE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(CourseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取科目列表
  void getCourseByParents(
    Function callback,
    Function errorback,
    int _userId,
    int _studentId,
  ) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "studentId": _studentId,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_COURSE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(CourseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取班级列表
  void getClassByUserId(
    Function callback,
    Function errorback,
    int _userId,
  ) async {
    FormData formData = new FormData.from({"userId": _userId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_CLASS),
            data: formData, options: _getOptions())
        .then((response) {
      callback(ClassEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取作业列表-教师
  void getHomeworkByTeacher(
    Function callback,
    Function errorback,
    int _userId,
    int _classId,
    int _courseId,
  ) async {
    FormData formData = new FormData.from(
        {"userId": _userId, "classId": _classId, "courseId": _courseId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_HOMEWORK),
            data: formData, options: _getOptions())
        .then((response) {
      callback(HomeworkEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取作业列表-学生
  void getHomework(
    Function callback,
    Function errorback,
    int _userId,
    int _courseId,
  ) async {
    FormData formData =
        new FormData.from({"userId": _userId, "courseId": _courseId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_HOMEWORK),
            data: formData, options: _getOptions())
        .then((response) {
      callback(HomeworkEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取作业列表-家长
  void getHomeworkByParents(
    Function callback,
    Function errorback,
    int _userId,
    int _studentId,
    int _courseId,
  ) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "studentId": _studentId,
      "courseId": _courseId,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_HOMEWORK),
            data: formData, options: _getOptions())
        .then((response) {
      callback(HomeworkEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 增加作业-教师
  void addHomeworkByTeacher(
      Function callback,
      Function errorback,
      int _userId,
      int _classId,
      int _courseId,
      String _homeworkContent,
      String _homeworkAttachment) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "classId": _classId,
      "courseId": _courseId,
      "homeworkContent": _homeworkContent,
      "homeworkAttachment": _homeworkAttachment
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_ADD_HOMEWORK),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 删除作业-教师
  void deleteHomeworkByTeacher(
    Function callback,
    Function errorback,
    int _homeworkId,
  ) async {
    FormData formData = new FormData.from({"homeworkId": _homeworkId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_DELETE_HOMEWORK),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 编辑作业-教师
  void editHomeworkByTeacher(
      Function callback,
      Function errorback,
      int _homeworkId,
      String _homeworkContent,
      String _homeworkAttachment) async {
    FormData formData = new FormData.from({
      "homeworkId": _homeworkId,
      "homeworkContent": _homeworkContent,
      "homeworkAttachment": _homeworkAttachment
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_EDIT_HOMEWORK),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取通知列表-教师
  void getNoticeByTeacher(
    Function callback,
    Function errorback,
    int _userId,
    int _classId,
  ) async {
    FormData formData =
        new FormData.from({"userId": _userId, "classId": _classId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_NOTICE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(NoticeEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取通知列表-学生
  void getNotice(
    Function callback,
    Function errorback,
    int _userId,
  ) async {
    FormData formData = new FormData.from({"userId": _userId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_NOTICE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(NoticeEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取通知列表-家长
  void getNoticeByParents(
    Function callback,
    Function errorback,
    int _userId,
    int _studentId,
  ) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "studentId": _studentId,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_NOTICE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(NoticeEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 增加通知-教师
  void addNoticeByTeacher(
      Function callback,
      Function errorback,
      int _userId,
      int _classId,
      String _noticeTitle,
      String _noticeContent,
      String _noticeAttachment) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "classId": _classId,
      "noticeTitle": _noticeTitle,
      "noticeContent": _noticeContent,
      "noticeAttachment": _noticeAttachment,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_ADD_NOTICE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 删除通知-教师
  void deleteNoticeByTeacher(
    Function callback,
    Function errorback,
    int _noticeId,
  ) async {
    FormData formData = new FormData.from({
      "noticeId": _noticeId,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_DELETE_NOTICE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 编辑通知-教师
  void editNoticeByTeacher(
    Function callback,
    Function errorback,
    int _noticeId,
    String _noticeTitle,
    String _noticeContent,
    String _noticeAttachment,
  ) async {
    FormData formData = new FormData.from({
      "noticeId": _noticeId,
      "noticeTitle": _noticeTitle,
      "noticeContent": _noticeContent,
      "noticeAttachment": _noticeAttachment
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_EDIT_NOTICE),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获消息列表
  void getChatList(
    Function callback,
    Function errorback,
    int _sendId,
    int _receiveId,
    int _chatMesg,
  ) async {
    FormData formData = new FormData.from(
        {"sendId": _sendId, "receiveId": _receiveId, "chatMesg": _chatMesg});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_CHAT_LIST),
            data: formData, options: _getOptions())
        .then((response) {
      callback(ChatEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获消息列表
  void getChat(Function callback, Function errorback, int _chatId) async {
    FormData formData = new FormData.from({"chatId": _chatId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_CHAT),
            data: formData, options: _getOptions())
        .then((response) {
      callback(ChatOneEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取正在聊天联系人列表
  void getChatContacts(
    Function callback,
    Function errorback,
    int _userId,
  ) async {
    FormData formData = new FormData.from({"userId": _userId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_CHAT_CONTACTS),
            data: formData, options: _getOptions())
        .then((response) {
      callback(ChatContactsEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取联系人列表-教师
  void getContactsByTeacher(
    Function callback,
    Function errorback,
    int _userId,
    int _classId,
    String _contactsType,
  ) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "classId": _classId,
      "contactsType": _contactsType
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_CONTACTS),
            data: formData, options: _getOptions())
        .then((response) {
      callback(ContactsEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取联系人列表--学生
  void getContactsByUser(
    Function callback,
    Function errorback,
    int _userId,
    String _contactsType,
  ) async {
    FormData formData =
        new FormData.from({"userId": _userId, "contactsType": _contactsType});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_CONTACTS),
            data: formData, options: _getOptions())
        .then((response) {
      callback(ContactsEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 获取联系人列表--家长
  void getContactsByParents(
    Function callback,
    Function errorback,
    int _userId,
    int _studentId,
    String _contactsType,
  ) async {
    FormData formData = new FormData.from({
      "userId": _userId,
      "studentId": _studentId,
      "contactsType": _contactsType,
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_GET_CONTACTS),
            data: formData, options: _getOptions())
        .then((response) {
      callback(ContactsEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 发送消息
  void addChat(
    Function callback,
    Function errorback,
    int _sendId,
    int _receiveId,
    int _chatType,
    String _chatContent,
  ) async {
    FormData formData = new FormData.from({
      "sendId": _sendId,
      "receiveId": _receiveId,
      "chatType": _chatType,
      "chatContent": _chatContent
    });
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_ADD_CHAT),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 删除和某一个人的消息
  void deleteChatList(
    Function callback,
    Function errorback,
    int _sendId,
    int _receiveId,
  ) async {
    FormData formData =
        new FormData.from({"sendId": _sendId, "receiveId": _receiveId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_DELETE_CHAT_LIST),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 删除一条消息
  void deleteChat(Function callback, Function errorback, int _chatId) async {
    FormData formData = new FormData.from({"chatId": _chatId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_DELETE_CHAT),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  /// 标记和某一个人的消息为已读
  void updateChatByUser(
    Function callback,
    Function errorback,
    int _sendId,
    int _receiveId,
  ) async {
    FormData formData =
        new FormData.from({"sendId": _sendId, "receiveId": _receiveId});
    DioManager.singleton.dio
        .post(Api.getPath(path: Api.USER_UPDATE_CHAT_USER),
            data: formData, options: _getOptions())
        .then((response) {
      callback(BaseEntity.fromJson(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  Options _getOptions() {
    Map<String, String> map = new Map();
    List<String> cookies = User().cookie;
    map["Cookie"] = cookies.toString();
    return Options(headers: map);
  }
}
