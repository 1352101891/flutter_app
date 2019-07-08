import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/eventbusutil.dart';
import 'package:flutter_app/model/BannerModel.dart';
import 'package:flutter_app/model/HotWordModel.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/model/PaperPageInfo.dart';
import 'package:flutter_app/model/WebsiteModel.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/util/ItemFactory.dart';
import 'package:flutter_app/widget/FlowContainer.dart';
import 'package:flutter_app/widget/FreshContainer.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';

typedef void ClickItem(bool isAdd,dynamic p ,String title,String url);

class CommonListview extends StatefulWidget {
  BannerModel bannerModel;

  CommonListview({this.bannerModel});

  @override
  State createState(){
    return getStateByType(bannerModel);
  }
}

class CommonList<T> extends State<CommonListview> with AutomaticKeepAliveClientMixin {
  BannerModel bannerModel;
  Set<T> checkObject=new Set();
  List<dynamic> data=new List();
  int pageno=0;
  bool isloading=true;
  String message = 'Unknown msg.';
  static const WebviewPage = const MethodChannel('com.flutter.gotowebview');


  CommonList(this.bannerModel);

  Future<void> getWebviewResult(Map<dynamic, dynamic> map) async {
    String msg;
    try {
      final int result = await WebviewPage.invokeMethod('open',map);
      msg = 'getresult is $result % .';
    } on PlatformException catch (e) {
      msg = "Failed to get result: '${e.message}'.";
    }
    setState(() {
      message = msg;
    });
  }

  @override
  void initState() {
    super.initState();
    print(bannerModel.title+"getDataSync:之前");
    getDataAsync(pageno);
    print(bannerModel.title+"getDataSync:之后");
    eventBus.on<ClearAllEvent>().listen((event) {
      print("ClearAllEvent:"+(event.flag?"true":"false"));
      if(event.flag){
        _clear();
      }
    });
  }

  void getDataAsync(int pn){
    actulGetData(pn,this);
  }


  void setLoadingStatus(bool flag){
    if(mounted){
      setState(() {
        isloading=flag;
      });
    }
  }

  @protected
  bool get wantKeepAlive=>true;

  void _clear(){
    setState(() {
      checkObject.clear();
    });
  }

  void _add(T p) {
    setState(() {
       checkObject.add(p);
    });
  }

  void _remove(T p){
    setState(() {
      checkObject.remove(p);
    });
  }

  void _clickItem(bool inCart,dynamic p,String title,String url){
    Map map={
      "title":title,
      "url":url,
    };
    getWebviewResult(Map<dynamic, dynamic>.from(map));
    if(inCart) {
      _add(p);
    }else{
      _remove(p);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(isloading){
      return new MaterialApp(
        home: new Scaffold(
            body: Center(
              child:LoadingWidget(status: STATUS.LOADING),
            )
        ),
      );
    }else {
      return Scaffold(
          body: Center(
              child: Align(
                alignment: Alignment.center,
                child: bannerModel.title=="搜索热词"?
                  FlowContainer(
                    delegate: MyFlowDelegate(),
                    children: data.map((p) =>
                        getItemWidgetByType(checkObject.contains(p), p, _clickItem)
                    ).toList(),
                  ):
                  FreshContainer(
                    child:ListView(
                      //不管什么平台这样设置,对于overscroll都可以监听到
                      physics: const ClampingScrollPhysics(),
                      children: data.map((p) =>
                          getItemWidgetByType(checkObject.contains(p), p, _clickItem)
                      ).toList(),
                    ),
                    refresh: () => getDataAsync(0),
                    loadMore: () => getDataAsync(pageno),
                    needLoadmore: needLoadmoreByType(bannerModel.title),
                  ),
              )
          )
      );
    }
  }
}


