// Flutter code sample for material.BottomNavigationBar.1

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/animation.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/FavorateListview.dart';
import 'package:flutter_app/page/HomeTabView.dart';
import 'package:flutter_app/page/LoginView.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/PageAnimation.dart';
import 'package:flutter_app/util/util.dart';
import 'model/UserInfoModel.dart';
import 'net/NetRequestUtil.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}
class _MyStatefulWidgetState extends State<MyStatefulWidget>  with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  UserInfoModel  userInfoModel;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  /// 页面控制器（`PageController`）组件，页面视图（`PageView`）的控制器。
  PageController _controller = PageController();


  @override
  void initState() {
    super.initState();
    gotoLogin();
  }

  void gotoLogin(){
    getAsyncPrefs(loginUserKey).then((username) {
      return getAsyncPrefs(username,defaultValue: null);
    }).then((userinfoStr) {
      if(userinfoStr==null){
        jumpToWidget(context, LoginPage(context), 0).then((value){
          if(value==null){
            showToast(context, loginFailed);
          }else{
            showToast(context, loginSuccess);
            setState(() {
              userInfoModel=value;
            });
          }
        });
        return;
      }
      Map map = json.decode(userinfoStr);
      setState(() {
        userInfoModel = UserInfoModel.fromJson(map);
      });
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    MainTabView(),
    MyHomePage(),
    AnimationHomePage(),
  ];

  static const navigationitem=const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      title: Text('Business'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      title: Text('School'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 跳到页面（`jumpToPage`）方法，更改显示在的页面视图（`PageView`）组件中页面。
      _controller.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tAppName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            tooltip: tSearch,
            onPressed: null,
          ),
        ],
      ),
      body: Builder(
          builder: (context) => PageView.builder(
          // 物理（`physics`）属性，页面视图应如何响应用户输入。
          // 从不可滚动滚动物理（`NeverScrollableScrollPhysics`）类，不允许用户滚动。
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _widgetOptions.elementAt(index);
          },
          itemCount: _widgetOptions.length,
          // 控制器（`controller`）属性，用于控制滚动此页面视图位置的对象。
          controller: _controller,
        )
      ),
      // 底部导航栏（`bottomNavigationBar`）属性，显示在脚手架（`Scaffold`）组件的底部。
      // 底部导航栏（`BottomNavigationBar`）组件，显示在应用程序底部的组件，
      // 用于在几个屏幕之间中进行选择，通常在三到五之间，再多就不好看了。
      bottomNavigationBar: BottomNavigationBar(
        // 项目（`items`）属性，位于底部导航栏中的交互组件，其中每一项都有一个图标和标题。
        items: navigationitem,
        // 目前的索引（`currentIndex`）属性，当前活动项的项目索引。
        currentIndex: _selectedIndex,
        // 固定颜色（`fixedColor`）属性，当BottomNavigationBarType.fixed时所选项目的颜色。
        fixedColor: Color(0xffFE7C30),
        // 在点击（`onTap`）属性，点击项目时调用的回调。
        onTap: _onItemTapped,
        // 定义底部导航栏（`BottomNavigationBar`）组件的布局和行为。
        type: BottomNavigationBarType.fixed,
      ),
      drawer:DrawerLayout(context,userInfoModel: userInfoModel),
    );
  }

  /// 释放相关资源。
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @protected
  bool get wantKeepAlive=>true;
}


class DrawerLayout extends StatefulWidget{
  UserInfoModel userInfoModel;
  BuildContext parentContext;
  DrawerLayout(this.parentContext,{this.userInfoModel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DrawerLayoutState();
  }
}

class DrawerLayoutState extends State<DrawerLayout>{
  DrawerLayoutState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Drawer(
      child:ListView(
          children:<Widget>[
            DrawerHeader(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                child: GestureDetector(
                  onTap: ()=>onpressEvent(widget.parentContext),
                  child: Stack(
                      alignment: Alignment.center,
                      children:<Widget>[
                        SizedBox(width: double.infinity,height: double.infinity,child: Container(color: Colors.blue,)),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                              Icon(Icons.account_circle,size: 80,color: Colors.white,),
                              Text(widget.userInfoModel!=null?widget.userInfoModel.username:"请登录")
                            ]
                        )
                      ]
                  ),
                )
            )
          ]..addAll(drawerList.map((f)=>
              ListTile(
                onTap:()=>DrawerItemClickaction(f.name),
                title: Text(f.name),
                leading: new CircleAvatar(
                  child: Icon(f.icon),
                  backgroundColor: null,
                ),
                trailing: Icon(Icons.chevron_right),
              )).toList())
      ),
    );
  }

  void DrawerItemClickaction(String name){
    if(drawerList[0].name==name){

    }
    if(drawerList[1].name==name){
      jumpToWidget(context,FavorateListview(drawerList[1].name),0).then((value){
        print("从收藏页面回到主页！");
      });
    }
  }

  void onpressEvent(BuildContext context){
    if(widget.userInfoModel==null){
      jumpToWidget(context,LoginPage(context),0).then((value){
        if(value!=null){
          showToast(context, loginSuccess);
          setState(() {
            widget.userInfoModel=value;
          });
        }
      });
    }else{
      logout(callback:(map){
        if(map[codeKey]==0){
          removeAsyncPrefs(widget.userInfoModel.username).then((boo){
            removeAsyncPrefs(loginUserKey);
          }).then((boo){
            showToast(context,logoutSuccess);
            clearModel();
          });
        }
      });
    }
  }

  void clearModel(){
    setState(() {
      widget.userInfoModel=null;
    });
  }

}