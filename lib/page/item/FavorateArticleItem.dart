

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/Util.dart';
import 'package:flutter_app/page/main/CommonListview.dart';

typedef void Callback(PaperModel p);

class FavorateArticleItem extends StatefulWidget with Util{
  final bool inCart;
  final PaperModel p;
  final ClickItem clickItem;
  final Callback cb;


  FavorateArticleItem(this.inCart, dynamic prod,this.clickItem,this.cb):p = prod,
        super(key: new ObjectKey(prod));

  @override
  State<StatefulWidget> createState() {
    return Article(inCart,p,clickItem);
  }
}

class Article extends State<FavorateArticleItem> with WidgetsBindingObserver,Util{
  final bool inCart;
  final PaperModel p;
  final ClickItem clickItem;
  GlobalKey key;
  double mWidth=200;

  Article(this.inCart,this.p,this.clickItem){
    if(p.collect==null){
      p.collect=false;
    }
    key = new GlobalKey(debugLabel:p.title);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration){ setState(() {
      mWidth= key.currentContext.size.width;
      print("mWidth:"+mWidth.toString());
    });});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print("size:width:"+size.toString());
    return ListTile(
//      leading: new CircleAvatar(
//        backgroundColor: _getColor(context,inCart),
//        child: Icon(Icons.insert_emoticon),
//      ),
      title: GestureDetector(
        onTap: () {
          clickItem(!inCart,p,p.title,p.link);
        },
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Row(
                key: key,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  SizedBox(
                    width:size.width*0.8-25,
                    child:Text(p.title,style: inCart?Theme.of(context).textTheme.subhead:Theme.of(context).textTheme.body1),
                  )
                ],
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
        ),
        trailing:GestureDetector(
          onTap:()=>_favorate(),
          child:Icon(Icons.favorite,size:25)
        )
    );
  }

  void _favorate(){
    String url="";
    url=uncollectOriginIdArticle.replaceFirst(articleidKey, p.originId.toString());
    request(url,type:1,callback:(map){
      if(map[codeKey]==successCode){
        setState(() {
          p.collect=!p.collect;
        });
        widget.cb(p);
      }else{
        showToast(context, map[msgKey]);
      }
    });
  }

}
