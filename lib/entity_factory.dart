import 'package:tomato_scfs/model/chat_contacts_entity.dart';
import 'package:tomato_scfs/model/chat_entity.dart';
import 'package:tomato_scfs/model/class_entity.dart';
import 'package:tomato_scfs/model/course_entity.dart';
import 'package:tomato_scfs/model/homework_entity.dart';
import 'package:tomato_scfs/model/notice_entity.dart';
import 'package:tomato_scfs/model/school_entity.dart';
import 'package:tomato_scfs/model/user_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "ClassEntity") {
      return ClassEntity.fromJson(json) as T;
    } else if (T.toString() == "ChatEntity") {
      return ChatEntity.fromJson(json) as T;
    } else if (T.toString() == "UserEntity") {
      return UserEntity.fromJson(json) as T;
    } else if (T.toString() == "NoticeEntity") {
      return NoticeEntity.fromJson(json) as T;
    } else if (T.toString() == "SchoolEntity") {
      return SchoolEntity.fromJson(json) as T;
    } else if (T.toString() == "HomeworkEntity") {
      return HomeworkEntity.fromJson(json) as T;
    } else if (T.toString() == "CourseEntity") {
      return CourseEntity.fromJson(json) as T;
    } else if (T.toString() == "ChatContactsEntity") {
      return ChatContactsEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
