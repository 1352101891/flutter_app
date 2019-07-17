/*
 * Created by 李卓原 on 2018/9/7.
 * email: zhuoyuan93@gmail.com
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/WebsiteModel.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/UserManager.dart';
import 'package:flutter_app/util/util.dart';
import 'dart:convert' as convert;

class AddWebsitePage extends StatefulWidget {
  String title;
  BuildContext parentContext;

  AddWebsitePage(this.parentContext,{this.title="登陆"});

  @override
  State<StatefulWidget> createState() => AddWebsitePageState();
}

class AddWebsitePageState extends State<AddWebsitePage> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  //密码的控制器
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    passController.dispose();
    phoneController.dispose();
    super.dispose();
  }

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
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      icon: Icon(Icons.title),
                      labelText: '请输入网址名称',
                    ),
                    autofocus: false,
                  )
              ),
              Container(
                  padding:EdgeInsets.fromLTRB(30,5,30,5),
                  child:TextField(
                    controller: passController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      icon: Icon(Icons.link),
                      labelText: '请输入网址',
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
                        onPressed: _add,
                        child: Text('添加'),
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
    if (phoneController.text.length ==0) {
      showToast(context,"请输入网址名称");
      return false;
    } else if (passController.text.length == 0) {
      showToast(context,"请输入网址");
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
  void _add() {
    if(gobalUserInfo==null){
      return;
    }
    if(inputValidate()){
      Map map={
        'name':phoneController.text,
        'link':passController.text,
      };
      request(collectWebSite,type:1,param: map, callback: (map){
            int code=map[codeKey];
            if(code!=successCode){
              showToast(context,map[msgKey]);
              return;
            }
            WebsiteModel websiteModel=WebsiteModel.fromJson(map[dataKey]);
            Navigator.pop(context,websiteModel);
          }
      );
    }
  }


  void onTextClear() {
    setState(() {
      phoneController.clear();
      passController.clear();
    });
  }
}


class _AddWebsiteApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  AddWebsitePage(context),
    );
  }
}


void main() {
  runApp(new _AddWebsiteApp());
}