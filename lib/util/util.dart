
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class util{
  //私有方法不可复写
  Color getColor(BuildContext context,bool inCart) {
    return inCart ? Theme.of(context).primaryColor:Colors.black54 ;
  }

  //私有方法不可复写
  TextStyle getTextStyle(BuildContext context,bool inCart) {
    if(!inCart){
      return new TextStyle(
        fontSize:10.0,
        color: Colors.black,
        decoration: TextDecoration.none,
      );
    }
    return new TextStyle(
      fontSize:10.0,
      color: Colors.blue,
      decoration: TextDecoration.none,
    );
  }
}

dynamic getAsyncPrefs(String key,{dynamic defaultValue}) async {
  // 获取实例
  var prefs = await SharedPreferences.getInstance();
  // 获取存储数据
  dynamic value = prefs.get(key)==null? defaultValue:prefs.get(key);

  return value;
  // 设置存储数据
}

setAsyncPrefs(String key,String value) async {
  // 获取实例
  var prefs = await SharedPreferences.getInstance();
  // 设置存储数据
  await prefs.setString(key, value);
}

bool isValidList(List list){
  if(list!=null && list.length>0){
    return true;
  }
  return false;
}

bool isEmptyString(String str){
  if(str!=null && str.length>0){
    return false;
  }
  return true;
}