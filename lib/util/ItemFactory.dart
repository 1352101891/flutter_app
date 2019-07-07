import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/HotWord.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/model/PaperPageInfo.dart';
import 'package:flutter_app/model/WebsiteModel.dart';
import 'package:flutter_app/net/Constants.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/page/CommonListview.dart';
import 'package:flutter_app/page/item/ArticleItem.dart';
import 'package:flutter_app/page/item/HotWordItem.dart';
import 'package:flutter_app/page/item/WebSiteItem.dart';

final Map tabsMap = {
  "首页文章": homeArticles,
  "置顶文章": topArticles,
  "常用网站": hotWebSites,
  "搜索热词": hotWords,
};


State getStateByType(String type){
  if(type=="首页文章" || type=="置顶文章") {
    return CommonList<PaperModel>();
  } else if(type=="常用网站") {
    return CommonList<WebsiteModel>();
  }else if(type=="搜索热词") {
    return CommonList<HotWord>();
  }
}

void actulGetData(int pn,CommonList t) async{

  String url=t.widget.bannerModel.url.replaceFirst('num',pn.toString());
  await get(url,callback:(map){
    if(pn==0){
      t.pageno=0;
      t.data.clear();
    }
    if(map!=null && map.length>0) {
      String type=t.widget.bannerModel.title;
      if(type=="首页文章") {
        PaperPageInfo pageInfo = new PaperPageInfo.fromJson(map["data"]);
        t.data.addAll(pageInfo.datas);
      }else if(type=="置顶文章"){
        List<PaperModel> list=new List();
        map["data"].forEach((v)=>list.add(new PaperModel.fromJson(v)));
        t.data.addAll(list);
      }else if(type=="常用网站") {
        List<WebsiteModel> list=new List();
        map["data"].forEach((v)=>list.add(new WebsiteModel.fromJson(v)));
        t.data.addAll(list);
      }else if(type=="搜索热词") {
        List<HotWord> list=new List();
        map["data"].forEach((v)=>list.add(new HotWord.fromJson(v)));
        t.data.addAll(list);
      }
      t.pageno++;
      t.setLoadingStatus(false);
    }
  });
}

Widget getWidgetByType(bool inCart, dynamic p, ClickItem clickitem){
  if(p is PaperModel){
    return ArticleItem(inCart,p,clickitem);
  }
  if(p is HotWord){
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
