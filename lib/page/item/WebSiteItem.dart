

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/model/WebsiteModel.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/UserManager.dart';
import 'package:flutter_app/util/Util.dart';

import 'package:flutter_app/page/main/CommonListview.dart';
class WebSiteItem  extends StatefulWidget{
  final bool inCart;
  final WebsiteModel p;
  final ClickItem clickItem;

  WebSiteItem(this.inCart,this.p,this.clickItem);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebSiteState(inCart,p,clickItem);
  }
}

class WebSiteState extends State<WebSiteItem> with Util{
  bool inCart;
  final WebsiteModel p;
  final ClickItem clickItem;

  WebSiteState(this.inCart, this.p,this.clickItem);

  void favorateWeb(BuildContext context){
    if(gobalUserInfo == null){
      return;
    }
    Map map={
      'name':p.name,
      'link':p.link,
    };
    request(collectWebSite,type: 1,param:map,callback:(map){
      if(map[codeKey]==successCode){
        clickItem(!inCart,p,p.name,p.link,jump:false);
        showToast(context,"收藏成功！");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress:()=>favorateWeb(context),
      onTap: () {
        clickItem(!inCart,p,p.name,p.link);
      },
      leading: new CircleAvatar(
        backgroundColor: getColor(context,inCart),
        child: Icon(Icons.link),
      ),
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,8),
              child:  Text(p.name, style: inCart?Theme.of(context).textTheme.subhead:Theme.of(context).textTheme.body1),
            ),
            Row(
                mainAxisAlignment:MainAxisAlignment.end ,
                children:<Widget>[
                  Flexible(child: Text("地址:"+p.link,maxLines: 1,overflow: TextOverflow.fade,style: getTextStyle(context,inCart))),
                ]
            ),
            Padding(padding:EdgeInsets.fromLTRB(0,10,0,0)),
            Container(decoration:new BoxDecoration(color: Colors.white)
                ,padding:EdgeInsets.fromLTRB(0,1,0,0)
            )
          ]
      ),
    );
  }
}
