import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/eventbusutil.dart';
import 'package:flutter_app/model/BannerModel.dart';
import 'package:flutter_app/util/ItemFactory.dart';
import 'package:flutter_app/widget/FreshContainer.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';

typedef void ClickItem(bool isAdd,dynamic p ,String title,String url);

class CommonListview extends StatefulWidget {
  BannerModel bannerModel;

  CommonListview({this.bannerModel});

  @override
  State createState(){
    return getStateByType(bannerModel.title);
  }
}

class CommonList<T> extends State<CommonListview> with AutomaticKeepAliveClientMixin {
  Set<T> checkObject=new Set();
  List<T> data=new List();
  int pageno=0;
  bool isloading=true;
  String message = 'Unknown msg.';
  static const WebviewPage = const MethodChannel('com.flutter.gotowebview');

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
    getDataAsync(pageno);
    eventBus.on<ClearAllEvent>().listen((event) {
      print("ClearAllEvent:"+(event.flag?"true":"false"));
      if(event.flag){
        _clear();
      }
    });
  }

  void getDataSync(int pn) async{
    await actulGetData(pn,this);
  }

  void getDataAsync(int pn){
    actulGetData(pn,this);
  }


  void setLoadingStatus(bool flag){
    setState(() {isloading=flag;});
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
                child: FreshContainer(
                  child: ListView(
                    //不管什么平台这样设置,对于overscroll都可以监听到
                    physics: const ClampingScrollPhysics(),
                    children: data.map((p) =>
                        getWidgetByType(checkObject.contains(p), p, _clickItem)
                    ).toList(),
                  ),
                  refresh: () => getDataSync(0),
                  loadMore: () => getDataSync(pageno),
                  needLoadmore: needLoadmoreByType(widget.bannerModel.title),
                ),
              )
          )
      );
    }
  }
}


