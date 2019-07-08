import 'dart:convert';

import 'package:flutter_app/util/util.dart';
import 'package:http/http.dart' as http;
import '../shopcart.dart';
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
void login(String username,String password,{Callback callback}) async{
  String url= loginUrl+"username="+username+"&password="+password;
  await post(url,callback:callback);
}


//同登陆返回数据格式
void register(String username,String password,String repassword,{Callback callback}) async{
  String url= registerUrl+"username="+username+"&password="+password+"&repassword="+repassword;
  await post(url,callback:callback);
}

//{
//"data": null,
//"errorCode": 0,
//"errorMsg": ""
//}
void logout({Callback callback}) async{
  await get(logoutUrl,callback:callback);
}


//get(dynamic url, { Map<String, String> headers }) → Future<Response>
//(必须)url:请求地址
//(可选)headers:请求头
void get(String url,{Callback callback}) async{
  await http.get(url).then((http.Response response) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    callback(responseData);
    //处理响应数据
  }).catchError((error) {
    print('$error错误');
  });
}


//post(dynamic url, { Map<String, String> headers, dynamic body, Encoding encoding }) → Future<Response>
//(必须)url:请求地址
//(可选)headers:请求头
//(可选)body:参数
//(编码)Encoding:编码 例子
void post(String url,{Object param,Callback callback}){
  addCookie(url).then((map)=>
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


Future<Map> addCookie(String url)async{
  Map<String,String> map = new Map();
  String cookies=await getAsyncPrefs(url,defaultValue:"");
  map[cookieKey]=cookies;
  return map;
}

//set-cookie
//JSESSIONID=B5287FF2B263655DE4EBBFF323E6BE88; Path=/; Secure; HttpOnly
void intercepCookie(http.Response response){
  String key=response.request.url.toString();
  bool exist=response.headers.containsKey(cookieKey);
  if(exist){
    String cookie=response.headers[cookieKey];
    setAsyncPrefs(key,cookie);
  }
}