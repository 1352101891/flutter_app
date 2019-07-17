import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/page/userpage/LoginView.dart';
import 'package:flutter_app/test/shopcart.dart';
import 'package:flutter_app/util/PageRouter.dart';
import 'package:flutter_app/util/eventbusutil.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/widget/FlowContainer.dart';

void main() => runApp(_mainApp());

List<Production> prods=<Production>[
  new Production(name:"哇哈哈",price:"2￥",icon:Icons.ac_unit),
  new Production(name:"加多宝",price:"5￥",icon:Icons.accessibility),
  new Production(name:"七喜",price:"3￥",icon:Icons.account_balance),
  new Production(name:"芬达",price:"3￥",icon:Icons.accessible),
  new Production(name:"百事可乐",price:"2.5￥",icon:Icons.access_time),
  new Production(name:"可口可乐",price:"2.5￥",icon:Icons.add_to_queue),
];


class _mainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title}) ;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _clearAll(BuildContext context) {
    jumpToWidgetDirect(context,LoginPage(context),1);
//    login("lq1111112","lq1111112",callback:(Map<String, dynamic> map)=> print(map.toString()));
//    eventBus.fire(new ClearAllEvent(true));
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.arrow_back_ios),
          tooltip: 'Air it',
          onPressed: null,
        ),
        title: Text('My Fancy Dress'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.playlist_play),
            tooltip: 'Air it',
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.playlist_add),
            tooltip: 'Restitch it',
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.playlist_add_check),
            tooltip: 'Repair it',
            onPressed: null,
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FlowContainer(
          delegate: MyFlowDelegate(),
          children: prods.map((p) => Container(
              width: 100,
              height: 50,
              decoration:new BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(10.0, 10.0)
                    )
                  ],
                  borderRadius:BorderRadius.all(Radius.circular(10.0)),
                  color: colors[Random().nextInt(4)]
              )
              ,child:Text(p.name)
              ,padding:EdgeInsets.fromLTRB(10,5,10,5)
          )).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:()=> _clearAll(context),
        tooltip: 'Increment',
        child: Icon(Icons.clear_all),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState');
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    print('reassemble');
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('deactivate');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose');
  }
}
