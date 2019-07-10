
import 'package:flutter/material.dart';

final String passwordNullTip="请填写密码！";
final String wrongSurePasswordTip="两次密码不一致，请重新输入！";
final String usernameTip="账号长度必须大于6位！";
final String loginSuccess="登陆成功！";
final String registerSuccess="注册成功！";

final Map tabsMap = {
  "首页文章": homeArticles,
  "置顶文章": topArticles,
  "常用网站": hotWebSites,
  "搜索热词": hotWords,
};

final colors=[ Colors.blue, Colors.orange, Colors.red, Colors.green,Colors.greenAccent,Colors.purpleAccent];
final String msgKey="errorMsg";
final String codeKey="errorCode";
final String cookieKey="set-cookie";
final String numKey="num";
final String articleidKey="articleid";

///*************接口
final String host="https://www.wanandroid.com/";

///**********登陆相关
final String loginUrl="/user/login/?";
final String registerUrl=host+"/user/register/?";
final String logoutUrl=host+"/user/logout/json";

///**********首页相关
final String getBanner=host+"/banner/json";
final String homeArticles=host+"/article/list/"+numKey+"/json";
final String hotWebSites=host+"/friend/json";
final String hotWords=host+"/hotkey/json";
final String topArticles=host+"/article/top/json";

///******   收藏文章接口  ******/
//GET
final String collectedArticles=host+"/lg/collect/list/"+numKey+"/json";
//Post
final String collectArticle =host+"/lg/collect/"+articleidKey+"/json";
//Post文章列表取消收藏Post
final String uncollectOriginIdArticle =host+"/lg/uncollect_originId/"+articleidKey+"/json";
//收藏列表取消收藏
//方法：POST
//参数：
//id:拼接在链接上
//originId:列表页下发，无则为-1
final String uncollectArticle =host+"/lg/uncollect/"+articleidKey+"/json";

//方法：POST
//参数：
//title，author，link
final String collectOutSideArticle =host+"/lg/collect/add/json";

///******   收藏网站的接口  ******/
//get
final String collectedWebSites=host+"/lg/collect/usertools/json";
//收藏网站
//方法：POST
//参数：name,link
final String collectWebSite =host+"/lg/collect/addtool/json";
//编辑网站
//方法：POST
//参数：id,name,link
final String updatetWebSite=host+"/lg/collect/updatetool/json";
//删除收藏网站
//方法：POST
//参数：id
final String deleteWebSite=host+"/lg/collect/deletetool/json";

///*******搜索接口*****/
//方法：POST
//参数：
//页码：拼接在链接上，从0开始。
//k ： 搜索关键词
final String searchArticles="https://www.wanandroid.com/article/query/"+numKey+"/json/?k=";