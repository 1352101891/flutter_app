import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/db/DBOperationArticle.dart';
import 'package:flutter_app/db/DBOperationHotWord.dart';
import 'package:flutter_app/model/HotWordModel.dart';
import 'package:flutter_app/model/PaperPageInfo.dart';
import 'package:flutter_app/page/item/ArticleItem.dart';
import 'package:flutter_app/util/Constants.dart';
import 'package:flutter_app/util/Util.dart';
import 'package:flutter_app/net/NetRequestUtil.dart';
import 'package:flutter_app/widget/FreshContainer.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

typedef void ClickItem(bool isAdd,dynamic p ,String title,String url);

class SearchListview extends StatefulWidget {
  final String title;
  SearchListview(this.title);

  @override
  State createState(){
    return SearchListState();
  }
}

class SearchListState extends State<SearchListview> with AutomaticKeepAliveClientMixin {
  Set<PaperModel> checkObject=new Set();
  List<dynamic> data=new List();
  int pageno=0;
  bool isloading=true;
  String message = 'Unknown msg.';
  TextEditingController _typeAheadController=new TextEditingController();
  String selectedWord="";
  static const WebviewPage = const MethodChannel('com.flutter.gotowebview');


  Future<void> getWebviewResult(Map<dynamic, dynamic> map) async {
    String msg;
    try {
      final int result = await WebviewPage.invokeMethod('open',map);
      msg = 'getresult is $result % .';
    } on PlatformException catch (e) {
      msg = "Failed to get result: '${e.message}'.";
    }
    setState(() {
      message = msg;
    });
  }

  @override
  void initState() {
    getDataAsync(0,"flutter");
    super.initState();
  }

  void getDataAsync(int pn,String word){
//    if(!isValidList(list)){
//      return;
//    }
//    String keyWords="";
//    list.forEach((f)=>keyWords+=linkMark+f);
    String url=searchArticles.replaceFirst(numKey,pn.toString())+word;
    request(url,type:1, callback: (map) {
      if(pn==0){
        pageno=0;
        data.clear();
      }
      int code = map[codeKey];
      if (code != successCode) {
        showToast(context, map[msgKey]);
        return;
      }
      PaperPageInfo pageInfo = new PaperPageInfo.fromJson(map[dataKey]);
      data.addAll(pageInfo.datas);
      if(isValidList(pageInfo.datas)){
        pageno++;
      }
      setLoadingStatus(false);
    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(isloading){
      return new Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child:LoadingWidget(status: STATUS.LOADING),
          )
      );
    }else {
      return Scaffold(
          appBar: AppBar(
              title: Text(widget.title),
          ),
          body: Center(
              child: Align(
                alignment: Alignment.center,
                child:
//                  TypeAheadFormField(
//                    textFieldConfiguration: TextFieldConfiguration(
//                        controller: this._typeAheadController,
//                        decoration: InputDecoration(
//                            labelText: 'City'
//                        )
//                    ),
//                    suggestionsCallback: (word) {
//                      return getSuggestions(word);
//                    },
//                    itemBuilder: (context, suggestion) {
//                      return ListTile(
//                        title: Text(suggestion),
//                      );
//                    },
//                    transitionBuilder: (context, suggestionsBox, controller) {
//                      return suggestionsBox;
//                    },
//                    onSuggestionSelected: (suggestion) {
//                      this._typeAheadController.text = suggestion;
//                    },
//                    validator: (value) {
//                      if (value.isEmpty) {
//                        return 'Please select a city';
//                      }
//                    },
//                    onSaved: (value){ this.selectedWord = value; saveWord(value);},
//                  ),
                  FreshContainer(
                    child:ListView(
                      //不管什么平台这样设置,对于overscroll都可以监听到
                      physics: const ClampingScrollPhysics(),
                      children: data.map((p) =>
                          ArticleItem(checkObject.contains(p), p, _clickItem)
                      ).toList(),
                    ),
                    refresh: () => getDataAsync(0,selectedWord),
                    loadMore: () => getDataAsync(pageno,selectedWord),
                    needLoadmore:true,
                  ),
              )
          )
      );
    }
  }

  Future<List<dynamic>> getSuggestions(String word)async{
    return DBOperationHotWord.query(word.trim());
  }

  Future<void> saveWord(String word)async{
    DBOperationHotWord.queryNum().then((num){
      HotWordModel model=new HotWordModel(num+1, "", word, 0, 0);
      return DBOperationHotWord.addNotMuti(model);
    });
  }


  void setLoadingStatus(bool flag){
    setState(() {
      isloading=flag;
    });
  }

  @protected
  bool get wantKeepAlive=>true;

  void _add(PaperModel p) {
    setState(() {
      checkObject.add(p);
    });
  }

  void _remove(PaperModel p){
    setState(() {
      checkObject.remove(p);
    });
  }

  void _clickItem(bool inCart,dynamic p,String title,String url,{bool jump}){
    Map map={
      "title":title,
      "url":url,
    };
    getWebviewResult(Map<dynamic, dynamic>.from(map));
    if(inCart) {
      _add(p);
    }else{
      _remove(p);
    }
    if(p is PaperModel){
      DBOperationArticle.queryNumByCon(p).then((num){
        if(num==0){
          DBOperationArticle.addNotMuti(p);
        }
      });
    }
  }
}


