class Api {
  static const String HOME_BANNER = "https://www.wanandroid.com/banner/json";

  static const String HOME_ARTICLE_LIST =
      "https://www.wanandroid.com/article/list/";

  /// 知识体系
  static const String SYSTEM_TREE = "https://www.wanandroid.com/tree/json";

  // 知识体系详情
  static const String SYSTEM_TREE_CONTENT =
      "https://www.wanandroid.com/article/list/";

  // 公众号名称
  static const String WX_LIST =
      "https://wanandroid.com/wxarticle/chapters/json";

  // 公众号文章
  static const String WX_ARTICLE_LIST =
      "https://wanandroid.com/wxarticle/list/";

  // 导航列表数据
  static const String NAVI_LIST = "https://www.wanandroid.com/navi/json";

  // 项目分类
  static const String PROJECT_TREE =
      "https://www.wanandroid.com/project/tree/json";

  // 项目列表
  static const String PROJECT_LIST = "https://www.wanandroid.com/project/list/";

  // 搜索热词
  static const String SEARCH_HOT_WORD =
      "https://www.wanandroid.com//hotkey/json";

  // 搜索结果
  static const String SEARCH_RESULT =
      "https://www.wanandroid.com/article/query/";

  // 用户登录
  // 用户注册
  // 收藏列表
  static const String COLLECTION_LIST =
      "https://www.wanandroid.com/lg/collect/list/";

  //常用网站
  static const String COMMON_WEBSITE = "https://www.wanandroid.com/friend/json";

  // 我的收藏-取消收藏
  static const String CANCEL_COLLECTION =
      "https://www.wanandroid.com/lg/uncollect/";

  // 我的收藏-新增收藏
  static const String ADD_COLLECTION =
      "https://www.wanandroid.com/lg/collect/add/json";

  // 网站收藏
  static const String WEBSITE_COLLECTION_LIST =
      "https://www.wanandroid.com/lg/collect/usertools/json";

  // 取消网站收藏
  static const String CANCEL_WEBSITE_COLLECTION =
      "https://www.wanandroid.com/lg/collect/deletetool/json";

  // 新增网站收藏
  static const String ADD_WEBSITE_COLLECTION =
      "https://www.wanandroid.com/lg/collect/addtool/json";

  // 编辑网站收藏
  static const String EDIT_WEBSITE_COLLECTION =
      "https://www.wanandroid.com/lg/collect/updatetool/json";

  // todo列表数据
  static const String TODO_LIST = "https://wanandroid.com/lg/todo/list/";

  // 新增todo数据
  static const String ADD_TODO = "https://www.wanandroid.com/lg/todo/add/json";

  // 更新todo数据
  static const String UPDATE_TODO =
      "https://www.wanandroid.com/lg/todo/update/";

  // 删除todo数据
  static const String DELETE_TODO =
      "https://www.wanandroid.com/lg/todo/delete/";

  // 仅更新todo完成状态
  static const String DONE_TODO = "https://www.wanandroid.com/lg/todo/done/";

  static const String USER_REGISTER = "user/register"; //注册
  static const String USER_LOGOUT = "user/logout"; //退出

  /// 根路径
  static const String ROOT = "http://localhost:8080/scfs_war_exploded";

  /// 用户学校信息
  static const String USER_GET_SCHOOL = "School/getSchool";

  /// 登录
  static const String USER_LOGIN = "User/login";

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

  /// 删除作业
  static const String USER_EDIT_HOMEWORK = "Homework/editHomework";

  /// 获取作业列表
  static const String USER_GET_NOTICE = "Notice/getNotice";

  /// 增加通知
  static const String USER_ADD_NOTICE = "Notice/addNotice";

  /// 删除通知
  static const String USER_DELETE_NOTICE = "Notice/deleteNotice";

  /// 删除通知
  static const String USER_EDIT_NOTICE = "Notice/editNotice";

  /// 获消息列表
  static const String USER_GET_CHAT_LIST = "Chat/getChatList";

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

  static String getPath({String root: ROOT, String path}) {
    StringBuffer sb = new StringBuffer(root);
    if (path != null && path.isNotEmpty) {
      sb.write('/$path');
    }
    return sb.toString();
  }
}
