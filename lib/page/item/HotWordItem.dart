

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/HotWordModel.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/Util.dart';
import '../CommonListview.dart';

class HotWordItem extends StatefulWidget with Util{
  final bool inCart;
  final HotWordModel p;
  final ClickItem clickItem;

  HotWordItem(this.inCart, dynamic prod,this.clickItem):p = prod,
        super(key: new ObjectKey(prod));

  @override
  State<StatefulWidget> createState() {
    return HotWordState(p.name);
  }
}

class HotWordState extends State<HotWordItem> with WidgetsBindingObserver{
  String name;
  GlobalKey key;
  double wrapWidth=80;
  HotWordState(this.name){
    key = new GlobalKey(debugLabel: name);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          widget.clickItem(!widget.inCart,widget.p,widget.p.name,widget.p.link);
        },
        child:Container(
            alignment: Alignment.center,
            width: wrapWidth,
            height: 40,
            decoration:new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(3.0, 3.0)
                  )
                ],
                borderRadius:BorderRadius.all(Radius.circular(10.0)),
                color: colors[Random().nextInt(6)]
            )
            ,child:Text(widget.p.name,maxLines: 1, key:key, textAlign:TextAlign.center,style:TextStyle(fontSize:14,color: Colors.white))
            ,padding:EdgeInsets.fromLTRB(5,5,5,5)
        )
    );
  }

  AppLifecycleState _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() { _notification = state; });
  }

  @override
  void initState() {
    super.initState();
    //监听该视图事件
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((duration){ setState(() {
      Text text= key.currentWidget as Text;
      wrapWidth= text.style.fontSize*text.data.length+5*2;
    });});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}