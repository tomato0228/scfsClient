import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static final String SP_COLOR_THEME_INDEX = "colorThemeIndex";
  static final String SP_LANGUAGE_TYPE = "languageType";

  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static String getPinyin(String str) {
    return PinyinHelper.getShortPinyin(str).substring(0, 1).toUpperCase();
  }

  static Color getChipBgColor(String name) {
    String pinyin = PinyinHelper.getFirstWordPinyin(name);
    pinyin = pinyin.substring(0, 1).toUpperCase();
    return nameToColor(pinyin);
  }

  static Color nameToColor(String name) {
    // assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  static String getTimeLine(BuildContext context, int timeMillis) {
//    LogUtil.e("countryCode: " +
//        Localizations.localeOf(context).countryCode +
//        "   languageCode: " +
//        Localizations.localeOf(context).languageCode);
    return TimelineUtil.format(timeMillis,
        locale: Localizations.localeOf(context).languageCode,
        dayFormat: DayFormat.Common);
  }

  static double getTitleFontSize(String title) {
    if (ObjectUtil.isEmpty(title) || title.length < 10) {
      return 18.0;
    }
    int count = 0;
    List<String> list = title.split("");
    for (int i = 0, length = list.length; i < length; i++) {
      String ss = list[i];
      if (RegexUtil.isZh(ss)) {
        count++;
      }
    }

    return (count >= 10 || title.length > 16) ? 14.0 : 18.0;
  }

  // 设置选择的主题色
  static setColorTheme(int colorThemeIndex) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(SP_COLOR_THEME_INDEX, colorThemeIndex);
  }

  static Future<int> getColorThemeIndex() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getInt(SP_COLOR_THEME_INDEX);
  }

  // 设置选择的语言
  static setLanguageType(String languageType) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(SP_LANGUAGE_TYPE, languageType);
  }

  static Future<String> getLanguageType() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(SP_LANGUAGE_TYPE);
  }

  /*
   * YYYY-MM-DD HH:MM:SS
   * 将一个日期格式化成友好格式，比如，1分钟以内的返回“刚刚”，
   * 当天的返回时分，当年的返回月日，否则，返回年月日
   * @param {Object} date
   */
  static formatDateToFriendly(String fromDateString) {
    if (fromDateString == null || fromDateString == '') {
      return fromDateString;
    }

    //当前日期以及对应的年月日时分秒
    var nowDate = DateTime.now();
    var nowDateYear = nowDate.year; // 年份
    var nowDateMonth = nowDate.month; // 月份
    var nowDateDay = nowDate.day; // 日期
    var nowDateHours = nowDate.hour; //24小时制
    var nowDateMinutes = nowDate.minute; // 分钟
    var nowDateSeconds = nowDate.second; // 秒

    // console.log('nowDate = '+ nowDateYear+'-'+(nowDateMonth<10?+'0'+nowDateMonth:nowDateMonth)+'-'+(nowDateDay<10?+'0'+nowDateDay:nowDateDay)
    //     +' '+(nowDateHours<10?+'0'+nowDateHours:nowDateHours)+':'+(nowDateMinutes<10?+'0'+nowDateMinutes:nowDateMinutes)+':'+
    //     (nowDateSeconds<10?+'0'+nowDateSeconds:nowDateSeconds));
    // console.log('fromDate = '+ fromDateString);
    //传过来的日期以及对应的年月日时分秒
    var formDateArray = fromDateString.split(" ")[0].split('-');
    var fromTimeArray = fromDateString.split(" ")[1].split(':');
    var fromDateYear = formDateArray[0]; // 年份
    var fromDateMonth = formDateArray[1]; // 月份
    var fromDateDay = formDateArray[2]; // 日期
    var fromDateHours = fromTimeArray[0]; //24小时制
    var fromDateMinutes = fromTimeArray[1]; // 分钟
    var fromDateSeconds = fromTimeArray[2]; // 秒
    //这部分是对05月01日 05时05分05秒这种进行格式化，判断的时候用这个
    var fromDateMonthTmp = fromDateMonth;
    if (fromDateMonth.substring(0, 1) == '0') {
      fromDateMonthTmp = fromDateMonth.substring(1, 2);
    }
    var fromDateDayTmp = fromDateDay;
    if (fromDateDay.substring(0, 1) == '0') {
      fromDateDayTmp = fromDateDay.substring(1, 2);
    }
    var fromDateHoursTmp = fromDateHours;
    if (fromDateHours.substring(0, 1) == '0') {
      fromDateHoursTmp = fromDateHours.substring(1, 2);
    }
    var fromDateMinutesTmp = fromDateMinutes;
    if (fromDateMinutes.substring(0, 1) == '0') {
      fromDateMinutesTmp = fromDateMinutes.substring(1, 2);
    }
    var fromDateSecondsTmp = fromDateSeconds;
    if (fromDateSeconds.substring(0, 1) == '0') {
      fromDateSecondsTmp = fromDateSeconds.substring(1, 2);
    }
    /******************* 一分钟之内 *******************/
    var nowDateYMDH = nowDateYear.toString() +
        '年' +
        nowDateMonth.toString() +
        '月' +
        nowDateDay.toString() +
        '日 ' +
        nowDateHours.toString();
    var fromDateYMDH = fromDateYear +
        '年' +
        fromDateMonthTmp +
        '月' +
        fromDateDayTmp +
        '日 ' +
        fromDateHoursTmp;
    //需要比较的time, 1分钟以内视作“刚刚”
    if (nowDateYMDH == fromDateYMDH &&
        nowDateMinutes - int.parse(fromDateMinutesTmp) < 2) {
      var remainMinuteSecond =
          (nowDateMinutes - int.parse(fromDateMinutesTmp)) * 60;
      var remainSecond = nowDateSeconds - int.parse(fromDateSecondsTmp);
      if (remainMinuteSecond + remainSecond < 60) {
        return '刚刚';
      }
    }
    /*************** 今天：只显示时间，格式为 时分      (已测试没问题) **********/
    //需要比较的 日期yyyy年M月d
    var nowDateYMD = nowDateYear.toString() +
        '年' +
        nowDateMonth.toString() +
        '月' +
        nowDateDay.toString() +
        '日';
    var fromDateYMD =
        fromDateYear + '年' + fromDateMonthTmp + '月' + fromDateDayTmp + '日';
    //返回时分
    if (nowDateYMD == fromDateYMD) {
      return fromDateHours + ':' + fromDateMinutes;
    }
    /*************** 昨天：不显示日期，显示“昨天”，格式为：“昨天” 时分； ***********/
    /*************** 前天：不显示日期，显示“前天”，格式为：“前天” 时分； ***********/
    var nowDateYM =
        nowDateYear.toString() + '年' + nowDateMonth.toString() + '月';
    var fromDateYM = fromDateYear + '年' + fromDateMonthTmp + '月';
    if (nowDateYM == fromDateYM) {
      if (nowDateDay - int.parse(fromDateDayTmp) == 1) {
        return '昨天 ' + fromDateHours + ':' + fromDateMinutes;
      } else if (nowDateDay - int.parse(fromDateDayTmp) == 2) {
        return '前天 ' + fromDateHours + ':' + fromDateMinutes;
      }
    }
    /******** 今年其他日期：不显示时间，仅显示月日，格式为：X月X日； ************/
    var nowDateY = nowDateYear.toString() + '年';
    var fromDateY = fromDateYear + '年';
    if (nowDateY == fromDateY) {
      return fromDateMonth +
          '月' +
          fromDateDay +
          '日 ' +
          fromDateHours +
          ':' +
          fromDateMinutes;
    }
    /******* 其它年份：不显示时间，仅显示年月日，格式为：XXXX年XX月XX日； **********/
    return fromDateYear + '年' + fromDateMonth + '月' + fromDateDay + '日';
  }
}
