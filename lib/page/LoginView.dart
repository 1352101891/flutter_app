/*
 * Created by 李卓原 on 2018/9/7.
 * email: zhuoyuan93@gmail.com
 *
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/model/UserInfoModel.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/PageAnimation.dart';
import 'package:flutter_app/util/util.dart';

import 'RegisterView.dart';

class LoginPage extends StatefulWidget {
  String title;
  BuildContext parentContext;

  LoginPage(this.parentContext,{this.title = "登陆"});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //手机号的控制器
  TextEditingController phoneController;

  //密码的控制器
  TextEditingController passController;

  String username, password;

  @override
  void initState() {
    phoneController = TextEditingController();
    passController = TextEditingController();
    print('initState');
    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    passController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    print('reassemble');
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('deactivate');
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 100),
              Icon(
                Icons.account_circle,
                size: 80,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 5),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      icon: Icon(Icons.account_box),
                      labelText: '账号长度必须大于6位',
                    ),
                    autofocus: false,
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: TextField(
                      controller: passController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        icon: Icon(Icons.lock),
                        labelText: '请输入密码',
                      ),
                      obscureText: true)),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  SizedBox(width: 30),
                  Expanded(
                      flex: 1,
                      child: RaisedButton(
                        color: Colors.lightBlue,
                        disabledColor: Colors.grey,
                        onPressed: _login,
                        child: Text('登录'),
                      )),
                  SizedBox(width: 30)
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 30),
                  Expanded(
                      flex: 1,
                      child: RaisedButton(
                        color: Colors.grey,
                        disabledColor: Colors.grey,
                        onPressed: () => _gotoRegister(context),
                        child: Text('注册'),
                      )),
                  SizedBox(width: 30)
                ],
              )
            ],
          ),
        ));
  }

  void _gotoRegister(BuildContext context) {
    jumpToWidget(context, RegisterPage(context), 0).then((value) {
      if (value == null) {
        return;
      }
      showToast(context, registerSuccess);
      UserInfoModel userInfoModel = value as UserInfoModel;
      phoneController.text = userInfoModel.username;
      passController.text = userInfoModel.password;
    });
  }

  bool inputValidate() {
    print({'phone': phoneController.text, 'password': passController.text});
    if (phoneController.text.length < 6) {
      showToast(context, usernameTip);
      return false;
    } else if (passController.text.length == 0) {
      showToast(context, passwordNullTip);
      return false;
    }
    return true;
  }

  void _login() {
    if (inputValidate()) {
      login(phoneController.text, passController.text, callback: (map) {
        int code = map[codeKey];
        if (code != 0) {
          showToast(context, map[msgKey]);
          return;
        }
        UserInfoModel userinfo = UserInfoModel.fromJson(map[dataKey]);
        String userinfoStr = json.encode(userinfo);
        //保存登陆账号信息
        setAsyncPrefs(userinfo.username, userinfoStr).then((boo) {
          if (boo) {
            return setAsyncPrefs(loginUserKey, userinfo.username);
          }
        }).then((boo) {
          if (boo) {
            Navigator.of(context).pop(userinfoStr);
          }
        });
      });
    }
  }

  void onTextClear() {
    setState(() {
      phoneController.clear();
      passController.clear();
    });
  }
}

class _LoginApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(context),
    );
  }
}

void main() {
  runApp(new _LoginApp());
}
