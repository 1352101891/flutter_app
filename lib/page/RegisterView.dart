/*
 * Created by 李卓原 on 2018/9/7.
 * email: zhuoyuan93@gmail.com
 *
 */

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/Tag.dart';
import 'package:flutter_app/model/UserInfoModel.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/util.dart';
import 'dart:convert' as convert;

class RegisterPage extends StatefulWidget {
  String title;


  RegisterPage({this.title="登陆"});

  @override
  State<StatefulWidget> createState() => RegisterPagePageState();
}

class RegisterPagePageState extends State<RegisterPage> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  //密码的控制器
  TextEditingController passController = TextEditingController();
  //确认密码控制器
  TextEditingController surepassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:SingleChildScrollView(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:100),
            Container(
                padding:EdgeInsets.fromLTRB(30,20,30,5),
                child:TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    icon: Icon(Icons.account_box),
                    labelText: '请输入注册的用户名',
                  ),
                  autofocus: false,
                )
            ),
            Container(
                padding:EdgeInsets.fromLTRB(30,5,30,5),
                child:TextField(
                  controller: passController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    icon: Icon(Icons.lock),
                    labelText: '请输入新密码',
                  ),
                  autofocus: false,)
            ),
            Container(
                padding:EdgeInsets.fromLTRB(30,5,30,5),
                child:TextField(
                  controller: surepassController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    icon: Icon(Icons.lock),
                    labelText: '请再次确认密码',
                  ),
                  autofocus: false,)
            ),
            SizedBox(height:20),
            Row(
              children:<Widget>[
                SizedBox(width:30),
                Expanded(
                    flex: 3,
                    child: RaisedButton(
                      color: Colors.blue,
                      disabledColor: Colors.grey,
                      onPressed: _login,
                      child: Text('注册'),
                    )
                ),
                SizedBox(width:10),
                Expanded(
                    flex: 1,
                    child: RaisedButton(
                      disabledColor: Colors.grey,
                      onPressed: onTextClear,
                      child: Text('清空'),
                    )
                ),
                SizedBox(width:30)
              ],
            )
          ],
        )
      ),
    );
  }

  bool inputValidate() {
    print({'phone': phoneController.text, 'password': passController.text});
    if (phoneController.text.length <6) {
      showToast(context,usernameTip);
      return false;
    } else if (passController.text.length == 0) {
      showToast(context,passwordNullTip);
      return false;
    } else if(surepassController.text!=passController.text){
      showToast(context,wrongSurePasswordTip);
      surepassController.clear();
      return false;
    }
    return true;
  }


   /*
    对象转化成json,再将json转化成对象的步骤
    Tag tag=new Tag("测试", "baidu.com");
    Map map=tag.toJson();
    String encode = json.encode(map);
    Map map1=json.decode(encode);
    Tag tag1=Tag.fromJson(map1);
  */
  void _login() {

    if(inputValidate()){
      register(phoneController.text,passController.text,passController.text,
        callback: (map){
          int code=map[codeKey];
          if(code!=0){
            showToast(context,map[msgKey]);
            return;
          }
          UserInfoModel userinfo= UserInfoModel.fromJson(map);
          String userinfoStr= json.encode(userinfo);
          setAsyncPrefs(userinfo.username, userinfoStr);
          showToast(context,map[msgKey]);
        }
      );
    }
  }


  void onTextClear() {
    setState(() {
      phoneController.clear();
      passController.clear();
      surepassController.clear();
    });
  }
}


class RegisterApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(),
    );
  }
}


void main() {
  runApp(new RegisterApp());
}