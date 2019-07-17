import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/db/DBOperationArticle.dart';
import 'package:flutter_app/model/PaperPageInfo.dart';
import 'package:flutter_app/page/item/FavorateArticleItem.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/Util.dart';
import 'package:flutter_app/util/eventbusutil.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/widget/FreshContainer.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/model/PaperModel.dart';

typedef void ClickItem(bool isAdd,dynamic p ,String title,String url);

class FavorateListview extends StatefulWidget {
  String title;
  FavorateListview(this.title);

  @override
  State createState(){
    return FavorateList();
  }
}

class FavorateList extends State<FavorateListview> with AutomaticKeepAliveClientMixin {
  Set<PaperModel> checkObject=new Set();
  List<dynamic> data=new List();
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
    print("getDataSync:之前");
    getDataAsync(pageno);
    print("getDataSync:之后");
    eventBus.on<ClearAllEvent>().listen((event) {
      print("ClearAllEvent:"+(event.flag?"true":"false"));
      if(event.flag){
        _clear();
      }
    });
  }

  void getDataAsync(int pn){
    String url=collectedArticles.replaceFirst(numKey,pn.toString());
    request(url, callback: (map) {
      if(pn==0){
        pageno=0;
        data.clear();
      }
      int code = map[codeKey];
      if (code != 0) {
        showToast(context, map[msgKey]);
        return;
      }
      PaperPageInfo pageInfo = new PaperPageInfo.fromJson(map[dataKey]);
      data.addAll(pageInfo.datas);
      if(isValidList(pageInfo.datas)){
        pageno++;
      }
      setLoadingStatus(false);
    });
  }


  void setLoadingStatus(bool flag){
    setState(() {
      isloading=flag;
    });
  }

  @protected
  bool get wantKeepAlive=>true;

  void _clear(){
    setState(() {
      checkObject.clear();
    });
  }

  void _add(PaperModel p) {
    setState(() {
       checkObject.add(p);
    });
  }

  void _remove(PaperModel p){
    setState(() {
      checkObject.remove(p);
    });
  }

  void _clickItem(bool inCart,dynamic p,String title,String url,{bool jump}){
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
    if(p is PaperModel){
      DBOperationArticle.queryNumByCon(p).then((num){
        if(num==0){
          DBOperationArticle.add(p);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(isloading){
      return new Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
            body: Center(
              child:LoadingWidget(status: STATUS.LOADING),
            )
        );
    }else {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
              child: Align(
                alignment: Alignment.center,
                child: FreshContainer(
                    child:ListView(
                      //不管什么平台这样设置,对于overscroll都可以监听到
                      physics: const ClampingScrollPhysics(),
                      children: data.map((p) =>
                          FavorateArticleItem(checkObject.contains(p), p, _clickItem,_removeCallback)
                      ).toList(),
                    ),
                    refresh: () => getDataAsync(0),
                    loadMore: () => getDataAsync(pageno),
                    needLoadmore:true,
                  ),
              )
          )
      );
    }
  }

  void _removeCallback(PaperModel p){
    if(checkObject.contains(p)){
      checkObject.remove(p);
    }
    if(data.contains(p)){
      data.remove(p);
    }
    setState(() {

    });
  }

}


