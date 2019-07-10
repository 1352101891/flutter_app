/*
 * Created by 李卓原 on 2018/9/7.
 * email: zhuoyuan93@gmail.com
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/Constants.dart';

class LoginPage extends StatefulWidget {
  String title;


  LoginPage({this.title="登陆"});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  //密码的控制器
  TextEditingController passController = TextEditingController();

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
            Icon(Icons.account_circle,size: 80,),
            Container(
              padding:EdgeInsets.fromLTRB(30,20,30,5),
              child:TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.account_box),
                  labelText: '账号长度必须大于6位',
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
                  labelText: '请输入密码',
                ),
                obscureText: true)
            ),
            SizedBox(height:20),
            Row(
              children:<Widget>[
                SizedBox(width:30),
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    color: Colors.blue,
                    disabledColor: Colors.grey,
                    onPressed: _login,
                    child: Text('登录'),
                  )
                ),
                SizedBox(width:30)
              ],
            )
          ],
        ),
      )
    );
  }

  void _login() {
    print({'phone': phoneController.text, 'password': passController.text});
    if (phoneController.text.length <6) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(usernameTip),
          ));
    } else if (passController.text.length == 0) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(passwordNullTip),
          ));
    }
  }

  void onTextClear() {
    setState(() {
      phoneController.clear();
      passController.clear();
    });
  }
}


class LoginApp extends StatelessWidget {
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
      home: LoginPage(),
    );
  }
}


void main() {
  runApp(new LoginApp());
}