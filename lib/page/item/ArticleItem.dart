

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/PageAnimation.dart';
import 'package:flutter_app/util/Util.dart';

import '../CommonListview.dart';

class ArticleItem extends StatefulWidget with Util{
  final bool inCart;
  final PaperModel p;
  final ClickItem clickItem;
  bool isCollectList=false;

  ArticleItem(this.inCart, dynamic prod,this.clickItem,{this.isCollectList=false}):p = prod,
        super(key: new ObjectKey(prod));

  @override
  State<StatefulWidget> createState() {
    return Article(inCart,p,clickItem);
  }
}

class Article extends State<ArticleItem> with WidgetsBindingObserver,Util{
  final bool inCart;
  final PaperModel p;
  final ClickItem clickItem;
  GlobalKey key;
  double mWidth=200;

  Article(this.inCart,this.p,this.clickItem){
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
        trailing: Offstage(
          offstage: widget.isCollectList,
          child:GestureDetector(
            onTap:()=>_favorate(),
            child:Icon((p.collect==null||p.collect)?Icons.favorite:Icons.favorite_border,size:25)
          )
        ),
    );
  }

  void _favorate(){
    String url="";
    if(p.collect){
      url=uncollectOriginIdArticle;
    }else{
      url=collectArticle;
    }
    url=url.replaceFirst(articleidKey, p.id.toString());
    request(url,type:1,callback:(map){
      if(map[codeKey]==successCode){
        setState(() {
          p.collect=!p.collect;
        });
      }else{
        showToast(context, map[msgKey]);
      }
    });
  }

}
