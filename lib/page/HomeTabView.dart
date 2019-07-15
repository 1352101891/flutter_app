// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_app/model/BannerModel.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/ItemFactory.dart';
import 'package:flutter_app/widget/FixTabBarView.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';

import 'CommonListview.dart';


class MainTabView extends StatefulWidget {

  @override
  State createState() {
    return _TabbedAppBar();
  }
}

class _TabbedAppBar extends State<MainTabView>  with SingleTickerProviderStateMixin{
  List<BannerModel> banners=[];
  bool isloading=true;
  PageController _pageController;
  TabController _tabController;


  @override
  void initState() {
    super.initState();
//    要通过json_serializable方式反序列化JSON字符串，我们不需要对先前的代码进行任何更改。
//    Map userMap = JSON.decode(json);
//    var user = new User.fromJson(userMap);
//    序列化也一样。调用API与之前相同。
//    String json = JSON.encode(user);
    Future((){ tabsMap.forEach((k, v) => banners.add(BannerModel(title: k,url: v))); })
        .then((v){
              _tabController = TabController(length: banners.length,vsync: this);
              _pageController = PageController();
              setState(() {isloading=false; });
            });
  }

  @override
  void dispose() {
    if(mounted)
      _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(isloading){

      return new MaterialApp(
          home: new Scaffold(
            body: Center(
                child:LoadingWidget(status: STATUS.LOADING),
              )
            ),
        );
    }else{
      return new MaterialApp(
        home:Scaffold(
          appBar:PreferredSize(
            preferredSize:Size(double.infinity, 50),
            child: Container(
              alignment: Alignment.center,
              height:50,
              decoration: new BoxDecoration(
//                  border: new Border.all(color: Color(0xFFFFFF00), width: 0.5), // 边色与边宽度
                color: Color(0xFF4068D1), // 底色
                shape: BoxShape.rectangle, // 默认值也是矩形
              ),
              child:TabBar(
                controller: _tabController,
                indicatorColor: Color(0xFFFFFFFF),
                labelColor: Color(0xFFFFFFFF),
                unselectedLabelColor: Color(0XCD333300),
                indicatorSize:TabBarIndicatorSize.tab,
                isScrollable: true,
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                tabs: banners.map((BannerModel ban) {
                  return new Tab(
                    text: ban.title,
                  );
                }).toList(),
              ),
            ),
          ),
          body:FixTabBarView(
            pageController: _pageController,
            tabController: _tabController,
            children: banners.map((BannerModel ban) {
              return new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new CommonListview(bannerModel: ban),
              );
            }).toList(),
          ),
        ),
      );
    }
  }
}


class _HomeTabView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: MainTabView(),
    );
  }
}

void main() {
  runApp(new _HomeTabView());
}