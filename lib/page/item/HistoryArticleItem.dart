

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/Util.dart';

import 'package:flutter_app/page/main/CommonListview.dart';

typedef void Callback(PaperModel p);

class HistoryArticleItem extends StatefulWidget with Util{
  final bool inCart;
  final PaperModel p;
  final ClickItem clickItem;
  final Callback cb;


  HistoryArticleItem(this.inCart, dynamic prod,this.clickItem,this.cb):p = prod,
        super(key: new ObjectKey(prod));

  @override
  State<StatefulWidget> createState() {
    return HistoryArticle(inCart,p,clickItem);
  }
}

class HistoryArticle extends State<HistoryArticleItem> with WidgetsBindingObserver,Util{
  final bool inCart;
  final PaperModel p;
  final ClickItem clickItem;
  GlobalKey key;

  HistoryArticle(this.inCart,this.p,this.clickItem){
    key = new GlobalKey(debugLabel:p.title);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print("size:width:"+size.toString());
    return ListTile(
        onTap: () {
          clickItem(!inCart,p,p.title,p.link);
        },
        title:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0,10,0,5),
                child: Text(p.title,style: inCart?Theme.of(context).textTheme.subhead:Theme.of(context).textTheme.body1)
              ),
              Row(
                  mainAxisAlignment:MainAxisAlignment.end ,
                  children:<Widget>[
                    Text("作者:"+p.author, style: getTextStyle(context,inCart)),
                    Padding(padding: EdgeInsets.fromLTRB(0,0,10,0)),
                    Text("时间:"+p.niceDate, style: getTextStyle(context,inCart)),
                    Padding(padding: EdgeInsets.fromLTRB(0,0,50,0)),
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
