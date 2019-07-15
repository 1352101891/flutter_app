
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/LoginView.dart';

import 'Constants.dart';
import 'Util.dart';

typedef Callback(bool success);

void gotoLogin(BuildContext context,Callback cb){
  getAsyncPrefs(loginUserKey).then((username) {
    return getAsyncPrefs(username,defaultValue: null);
  }).then((userinfoStr) {
    if(userinfoStr==null){
      _jumpToWidget(context, LoginPage(context), 0).then((value){
        if(value==null){
          cb(false);
          showToast(context, loginFailed);
        }else{
          cb(true);
          showToast(context, loginSuccess);
        }
      });
      return;
    }
    cb(true);
  });
}


/// animationType 0无动画，1平移动画，2透明动画
Future<dynamic> jumpToWidget(BuildContext context,Widget widget,int animationType,{bool needLogged=true}) async{
  if(needLogged){
    gotoLogin(context,(bool boo){
      if(boo){
        _jumpToWidget(context,widget,animationType);
      }else{
        showToast(context, notLogged);
      }
    });
  }
}

/// animationType 0无动画，1平移动画，2透明动画
Future<dynamic> _jumpToWidget(BuildContext context,Widget widget,int animationType) async{

  if(animationType==0){
    return await Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
      return widget;
    }));
  }else if(animationType==1){
    return await Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return widget;
    }, transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      // 添加一个透明动画
      return createFadeTransition(animation, child);
    }));
  }else{
    return await Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return widget;
    }, transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,) {
      // 添加一个平移动画
      return createSlideTransition(animation, child);
    }));
  }
}

/// 创建一个平移变换
/// 跳转过去查看源代码，可以看到有各种各样定义好的变换
FadeTransition createFadeTransition(Animation<double> animation, Widget child) {
  return new FadeTransition(opacity: new Tween(begin: 0.0,end: 1.0).animate(animation),child: child);
}

SlideTransition createSlideTransition(Animation<double> animation, Widget child) {
  return new SlideTransition(
    position: new Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(animation),
    child: child, // child is the value returned by pageBuilder
  );
}
