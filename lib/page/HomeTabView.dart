// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_app/model/BannerModel.dart';
import 'package:flutter_app/net/Constants.dart';
import 'package:flutter_app/util/ItemFactory.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';

import 'CommonListview.dart';


class HomeTabView extends StatefulWidget {

  @override
  State createState() {
    return _TabbedAppBar();
  }
}

class _TabbedAppBar extends State<HomeTabView>  {
  List<BannerModel> banners=[];
  bool isloading=true;
  //私有方法不可复写
  Color _getColor(BuildContext context) {
    return  Theme.of(context).primaryColor;
  }


  @override
  Widget build(BuildContext context) {
    if(isloading){
//    要通过json_serializable方式反序列化JSON字符串，我们不需要对先前的代码进行任何更改。
//    Map userMap = JSON.decode(json);
//    var user = new User.fromJson(userMap);
//    序列化也一样。调用API与之前相同。
//    String json = JSON.encode(user);
      Future((){ tabsMap.forEach((k, v) => banners.add(BannerModel(title: k,url: v))); })
          .then((v){setState(() {isloading=false; });});

      return new MaterialApp(
          home: new Scaffold(
            body: Center(
                child:LoadingWidget(status: STATUS.LOADING),
              )
            ),
        );
    }else{
      return new MaterialApp(
        home: new DefaultTabController(
          length: banners.length,
          child:new Scaffold(
            appBar: new PreferredSize(
              preferredSize:Size(double.infinity, 50),
              child: Container(
                alignment: Alignment.center,
                height:50,
                decoration: new BoxDecoration(
//                  border: new Border.all(color: Color(0xFFFFFF00), width: 0.5), // 边色与边宽度
                  color: Color(0xFF4068D1), // 底色
                  shape: BoxShape.rectangle, // 默认值也是矩形
                ),
                child: new TabBar(
                  indicatorColor: Color(0xFFFFFFFF),
                  labelColor: Color(0xFFFFFFFF),
                  unselectedLabelColor: Color(0XCD333300),
                  indicatorSize:TabBarIndicatorSize.tab,
                  isScrollable: true,
                  tabs: banners.map((BannerModel ban) {
                    return new Tab(
                      text: ban.title,
                    );
                  }).toList(),
                ),
              ),
            ),
            body: new TabBarView(
              children: banners.map((BannerModel ban) {
                return new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new CommonListview(bannerModel: ban),
                );
              }).toList(),
            ),
          ),
        ) ,
      );
    }
  }
}


void main() {
  runApp(new HomeTabView());
}