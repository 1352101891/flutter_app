

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/HotWordModel.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/util.dart';
import '../CommonListview.dart';

class HotWordItem extends StatelessWidget with util{
  final bool inCart;
  final HotWordModel p;
  final ClickItem clickItem;

  HotWordItem(this.inCart, dynamic prod,this.clickItem):p = prod,
        super(key: new ObjectKey(prod));

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        clickItem(!inCart,p,p.name,p.link);
      },
      child:Container(
        alignment: Alignment.center,
        width: 80,
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
        ,child:Text(p.name, textAlign:TextAlign.center,style: inCart?Theme.of(context).textTheme.subhead:Theme.of(context).textTheme.body1)
        ,padding:EdgeInsets.fromLTRB(5,5,5,5)
      )
    );
  }
}
