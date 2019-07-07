

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/util/util.dart';

import '../CommonListview.dart';

class ArticleItem extends StatelessWidget with util{
  final bool inCart;
  final PaperModel p;
  final ClickItem clickItem;

  ArticleItem(this.inCart, dynamic prod,this.clickItem):p = prod,
        super(key: new ObjectKey(prod));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        clickItem(!inCart,p,p.title,p.link);
      },
//      leading: new CircleAvatar(
//        backgroundColor: _getColor(context,inCart),
//        child: Icon(Icons.insert_emoticon),
//      ),
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            new Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,8),
              child:  Text(p.title, style: inCart?Theme.of(context).textTheme.subhead:Theme.of(context).textTheme.body1),
            ),
            Row(
                mainAxisAlignment:MainAxisAlignment.end ,
                children:<Widget>[
                  Text("作者:"+p.author, style: getTextStyle(context,inCart)),
                  Padding(padding: EdgeInsets.fromLTRB(0,0,10,0)),
                  Text("时间:"+p.niceDate, style: getTextStyle(context,inCart))
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
