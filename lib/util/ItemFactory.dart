import 'package:flutter/cupertino.dart';
import 'package:flutter_app/db/DBOperationHotWord.dart';
import 'package:flutter_app/model/BannerModel.dart';
import 'package:flutter_app/model/HotWordModel.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/model/PaperPageInfo.dart';
import 'package:flutter_app/model/WebsiteModel.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/page/main/CommonListview.dart';
import 'package:flutter_app/page/item/ArticleItem.dart';
import 'package:flutter_app/page/item/HotWordItem.dart';
import 'package:flutter_app/page/item/WebSiteItem.dart';
import 'package:flutter_app/util/util.dart';
import 'package:flutter_app/widget/FlowContainer.dart';

import 'UserManager.dart';


State getStateByType(BannerModel bannerModel){
  String type=bannerModel.title;
  if(type=="首页文章" ) {
    return CommonList<PaperModel>(bannerModel);
  }else if(type=="置顶文章"){
    return CommonList<PaperModel>(bannerModel);
  }else if(type=="常用网站") {
    return CommonList<WebsiteModel>(bannerModel);
  }else if(type=="搜索热词") {
    return CommonList<HotWordModel>(bannerModel);
  }
}

void actulGetData(int pn,CommonList t) {
  String url=t.bannerModel.url.replaceFirst(numKey,pn.toString());
  request(url,callback:(map){
    if(pn==0){
      t.pageno=0;
      t.data.clear();
    }
    List<dynamic> list=new List();
    if(map!=null && map.length>0) {
      String type=t.bannerModel.title;
      if(type=="首页文章") {
        PaperPageInfo pageInfo = new PaperPageInfo.fromJson(map[dataKey]);
        list=pageInfo.datas;
        t.data.addAll(list);
      }else if(type=="置顶文章"){
        List temp=map[dataKey];
        temp.forEach((v)=>list.add(new PaperModel.fromJson(v)));
        t.data.addAll(list);
      }else if(type=="常用网站") {
        map[dataKey].forEach((v)=>list.add(new WebsiteModel.fromJson(v)));
        t.data.addAll(list);
      }else if(type=="搜索热词") {
        map[dataKey].forEach((v)=>list.add(new HotWordModel.fromJson(v)));
        DBOperationHotWord.batch(list).then((_)=> print("插入关键字成功！"));
        t.data.addAll(list);
      }
      if(isValidList(list)){
        t.pageno++;
      }
      t.setLoadingStatus(false);
    }
  });
}

Widget getItemWidgetByType(bool inCart, dynamic p, ClickItem clickitem){
  if(p is PaperModel){
    return ArticleItem(inCart,p,clickitem);
  }
  if(p is HotWordModel){
    return HotWordItem(inCart,p,clickitem);
  }
  if(p is WebsiteModel){
    return WebSiteItem(inCart,p,clickitem);
  }
}


bool needLoadmoreByType(String type){
  if(type=="首页文章" ) {
    return  true;
  }else if( type=="置顶文章"){
    return  false;
  }else if(type=="常用网站") {
    return  false;
  }else if(type=="搜索热词") {
    return  false;
  }
  return false;
}
