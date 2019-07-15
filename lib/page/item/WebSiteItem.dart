

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/model/WebsiteModel.dart';
import 'package:flutter_app/util/Util.dart';

import '../CommonListview.dart';

class WebSiteItem extends StatelessWidget with Util{
  final bool inCart;
  final WebsiteModel p;
  final ClickItem clickItem;

  WebSiteItem(this.inCart, dynamic prod,this.clickItem):p = prod,
        super(key: new ObjectKey(prod));

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
