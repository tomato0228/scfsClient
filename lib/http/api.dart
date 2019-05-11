class Api {
  /// 根路径
//  static const String ROOT = "http://localhost:8080/scfs_war_exploded";
  static const String ROOT = "http://192.168.0.108:8080/scfs_war_exploded";

  /// 登录
  static const String USER_LOGIN = "User/login";

  /// 注册
  static const String USER_SIGNIN = "User/signin";

  /// 用户信息更改
  static const String USER_UPDATE = "User/update";

  /// 验证手机号码或邮箱是否存在
  static const String USER_VERIFY_USER_ACC = "User/verifyUserAcc";

  /// 发送验证码
  static const String USER_SEND_CODE = "User/sendValidationCode";

  /// 验证验证码
  static const String USER_VERIFY_CODE = "User/verifyValidationCode";

  /// 搜索联系人
  static const String USER_SEARCH_USER = "User/searchUser";

  /// 添加家长
  static const String USER_ADD_PARENTS = "User/addParents";

  /// 家长获取学生列表
  static const String USER_GET_STUDENT_LIST = "User/getStudentList";

  /// 用户学校信息
  static const String USER_GET_SCHOOL = "School/getSchool";

  /// 获取科目列表
  static const String USER_GET_COURSE = "Course/getCourse";

  /// 获取班级列表
  static const String USER_GET_CLASS = "Class/getClass";

  /// 获取作业列表
  static const String USER_GET_HOMEWORK = "Homework/getHomework";

  /// 增加作业
  static const String USER_ADD_HOMEWORK = "Homework/addHomework";

  /// 删除作业
  static const String USER_DELETE_HOMEWORK = "Homework/deleteHomework";

  /// 编辑作业
  static const String USER_EDIT_HOMEWORK = "Homework/editHomework";

  /// 获取作业列表
  static const String USER_GET_NOTICE = "Notice/getNotice";

  /// 增加通知
  static const String USER_ADD_NOTICE = "Notice/addNotice";

  /// 删除通知
  static const String USER_DELETE_NOTICE = "Notice/deleteNotice";

  /// 编辑通知
  static const String USER_EDIT_NOTICE = "Notice/editNotice";

  /// 获消息列表
  static const String USER_GET_CHAT_LIST = "Chat/getChatList";

  /// 获消息
  static const String USER_GET_CHAT = "Chat/getChat";

  /// 获取正在聊天联系人列表
  static const String USER_GET_CHAT_CONTACTS = "Chat/getChatContacts";

  /// 获取联系人列表
  static const String USER_GET_CONTACTS = "Chat/getContacts";

  /// 发送消息
  static const String USER_ADD_CHAT = "Chat/addChat";

  /// 删除和某一个人的消息
  static const String USER_DELETE_CHAT_LIST = "Chat/deleteChatList";

  /// 删除一条消息
  static const String USER_DELETE_CHAT = "Chat/deleteChat";

  /// 标记消息为已读
  static const String USER_UPDATE_CHAT_USER = "Chat/updateChatByUser";

  /// 拼接路径
  static String getPath({String root: ROOT, String path}) {
    StringBuffer sb = new StringBuffer(root);
    if (path != null && path.isNotEmpty) {
      sb.write('/$path');
    }
    return sb.toString();
  }
}
