

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/HotWord.dart';
import 'package:flutter_app/util/util.dart';
import '../CommonListview.dart';

class HotWordItem extends StatelessWidget with util{
  final bool inCart;
  final HotWord p;
  final ClickItem clickItem;

  HotWordItem(this.inCart, dynamic prod,this.clickItem):p = prod,
        super(key: new ObjectKey(prod));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        clickItem(!inCart,p,p.name,p.link);
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
              child:  Text(p.name, style: inCart?Theme.of(context).textTheme.subhead:Theme.of(context).textTheme.body1),
            ),
//            Row(
//                mainAxisAlignment:MainAxisAlignment.end ,
//                children:<Widget>[
//                  Text(""+p.link, style: getTextStyle(context,inCart)),
//                ]
//            ),
            Padding(padding:EdgeInsets.fromLTRB(0,10,0,0)),
            Container(decoration:new BoxDecoration(color: Colors.white)
                ,padding:EdgeInsets.fromLTRB(0,1,0,0)
            )
          ]
      ),
    );
  }
}
