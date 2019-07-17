import 'dart:convert';

import 'package:flutter_app/test/shopcart.dart';
import 'package:flutter_app/util/util.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_app/util/Constants.dart';

typedef Callback(Map<String, dynamic> responseData);

//get(getBanner,
//  (map){
//    map["data"].forEach((item){
//      var bm = new BannerModel.fromJson(item);
//      banners.add(bm);
//    });
//    setState(() {isloading=false; });
//  }
//);


//{
//"data": {
//"admin": false,
//"chapterTops": [
//
//],
//"collectIds": [
//
//],
//"email": "",
//"icon": "",
//"id": 26646,
//"nickname": "lq1111112",
//"password": "",
//"token": "",
//"type": 0,
//"username": "lq1111112"
//},
//"errorCode": 0,
//"errorMsg": ""
//}
void login(String username,String password,{Callback callback}){
  String url= loginUrl+"username="+username+"&password="+password;
  post(url,callback:callback);
}


//同登陆返回数据格式
void register(String username,String password,String repassword,{Callback callback}) {
  String url= registerUrl+"username="+username+"&password="+password+"&repassword="+repassword;
  post(url,callback:callback);
}

//{
//"data": null,
//"errorCode": 0,
//"errorMsg": ""
//}
void logout({Callback callback}) {
  get(logoutUrl,callback:callback);
}


//get(dynamic url, { Map<String, String> headers }) → Future<Response>
//(必须)url:请求地址
//(可选)headers:请求头
void get(String url,{Callback callback}) {
  http.get(url).then((http.Response response) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    callback(responseData);
    //处理响应数据
  }).catchError((error) {
    print('$error错误');
  });
}

///0是get，1是post
void request(String url,{int type=0,bool addCookies=true,Object param,Callback callback}) {
  if(addCookies) {
    Future<Map<dynamic, dynamic>> future = addCookie(loginUrl);
    future.then((map){
      if(type==0){
        return http.get(url, headers: map);
      }else{
        return http.post(url, headers: map, body: param, encoding: Utf8Codec());
      }}
    ).then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      callback(responseData);
      //处理响应数据
    }).catchError((error) {
      print('$error错误');
    });
  }else{
    Future<Response>  futureResponce;
    if(type==0){
      futureResponce=http.get(url);
    }else{
      futureResponce=http.post(url,body: json.encode(param),encoding: Utf8Codec());
    }
    futureResponce.then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      callback(responseData);
      //处理响应数据
    }).catchError((error) {
      print('$error错误');
    });
  }
}


//post(dynamic url, { Map<String, String> headers, dynamic body, Encoding encoding }) → Future<Response>
//(必须)url:请求地址
//(可选)headers:请求头
//(可选)body:参数
//(编码)Encoding:编码 例子
void post(String url,{Object param,Callback callback}){
  addCookie(loginUrl).then((map)=>
    http.post(url,headers:map,body: json.encode(param),encoding: Utf8Codec())
  ).then((http.Response response) {
    intercepCookie(response);
    final Map<String, dynamic> responseData = json.decode(response.body);
    callback(responseData);
    //处理响应数据
  }).catchError((error) {
    print('$error错误');
  });
}



Future<Map> addCookie(String url)async{
  Map<String,String> map = new Map();
  String cookies=await getAsyncPrefs(url,defaultValue:"");
  map[requestCookieKey]=cookies;
  return map;
}

//set-cookie
//JSESSIONID=B5287FF2B263655DE4EBBFF323E6BE88; Path=/; Secure; HttpOnly
void intercepCookie(http.Response response){
  bool exist=response.headers.containsKey(responseCookieKey);
  if(exist){
    String cookie=response.headers[responseCookieKey];
    setAsyncPrefs(loginUrl,cookie);
    print("cookie："+cookie);
  }
}




void addProduct(Production product) async {
  Map<String, dynamic> param = {
    'name': product.name,
    'icon': product.icon,
    'price': product.price
  };
  try {
    final http.Response response = await http.post(
        'https://flutter-cn.firebaseio.com/products.json',
        body: json.encode(param),
        encoding: Utf8Codec());

    final Map<String, dynamic> responseData = json.decode(response.body);
    print('$responseData 数据');

  } catch (error) {
    print('$error错误');
  }
}