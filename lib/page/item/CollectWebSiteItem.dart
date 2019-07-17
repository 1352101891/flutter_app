

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/model/WebsiteModel.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/UserManager.dart';
import 'package:flutter_app/util/Util.dart';

import 'package:flutter_app/page/main/CommonListview.dart';
typedef void Callback(WebsiteModel p);
class FavorateWebSiteItem extends StatelessWidget with Util{
  final bool inCart;
  final WebsiteModel p;
  final ClickItem clickItem;
  final Callback cb;

  FavorateWebSiteItem(this.inCart, dynamic prod,this.clickItem,this.cb):p = prod,
        super(key: new ObjectKey(prod));

  void remove(BuildContext context){
    if(gobalUserInfo == null){
      return;
    }
    Map map={
      'id':p.id.toString(),
    };
    request(deleteWebSite,type: 1,param:map,callback:(map){
      if(map[codeKey]==successCode){
        showToast(context,"删除成功！");
        cb(p);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: new CircleAvatar(
        backgroundColor: getColor(context,inCart),
        child: Icon(Icons.link),
      ),
      title: GestureDetector(
        onTap: () { clickItem(!inCart,p,p.name,p.link);},
        child: Column(
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
        )
      ),
      trailing: GestureDetector(
        onTap: ()=>remove(context),
        child: Icon(Icons.remove_circle_outline),
      ),
    );
  }
}
