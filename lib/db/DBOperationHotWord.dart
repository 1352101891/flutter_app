
import 'package:flutter_app/model/HotWordModel.dart';
import 'package:flutter_app/util/Util.dart';
import 'package:sqflite/sqflite.dart';
import 'DBHelper.dart';
//int id;
//String link;
//String name;
//int order;
//int visible;
class DBOperationHotWord{
  static String tablename="HotWord";
  static String createHotWordTableSql=
      "CREATE TABLE  if not exists HotWord("
      "id int,"
      "name varchar(255),"
      "link varchar(255),"
      "order int,"
      "visible int" ;

  static Future<int> addNotMuti(HotWordModel pm) async {
    if(pm.id==null){
      pm.id=0;
    }
    Database db = await open();

    String sql =
        "INSERT INTO "+tablename+"  VALUES('${pm.id}','${pm.name}','${pm.link}','${pm.order}','${pm.visible}')";
    return db.rawInsert(sql,null);
  }

  static Future<void> delete(HotWordModel pm) async {
    Database db = await open();

    //删除最近一条
    String sql = "DELETE FROM "+tablename+"  where id = ${pm.id}";
    int count = await db.rawDelete(sql);

    return db.close();
  }

  static Future<void> update(HotWordModel pm) async {
    Database db = await open();
    await delete(pm);
    await addNotMuti(pm);
    return db.close();
  }

  static Future<int> queryNumByCon(HotWordModel pm) async {
    Database db = await open();
    int count = Sqflite.firstIntValue(await db.rawQuery("select count(*) from  "+tablename+" where id="+pm.id.toString()));
    await db.close();
    return count;
  }

  static Future<int> queryNum() async {
    Database db = await open();
    int count = Sqflite.firstIntValue(await db.rawQuery("select count(*) from  "+tablename));
    await db.close();
    return count;
  }

  static  Future<List<HotWordModel>>  queryByPageno(int pageno) async {
    List<HotWordModel> temp=new List();
    Database db = await open();
    List<Map> list = await db.rawQuery("select * from  "+tablename+"  limit 10 offset "+ (pageno*10).toString());
    if(isValidList(list)){
      temp=list.map((f){
        HotWordModel paperModel=new HotWordModel.fromJson(f);
        return paperModel;
      }).toList();
    }
    await db.close();
    return temp;
  }


  static Future<List<HotWordModel>>  query(String word) async {
    String where =" where ";
    if(!isEmptyString(word)){
      List<String> temp = word.split("");
      temp.forEach((f){
        where+= " name like '%"+f+"%' and";
      });
      where=where.substring(0,where.length-3);
    }
    List<HotWordModel> temp=new List();
    Database db = await open();
    List<Map> list = await db.rawQuery("select * from  "+tablename +where);
    if(isValidList(list)){
      temp=list.map((f){
        HotWordModel paperModel=new HotWordModel.fromJson(f);
        return paperModel;
      }).toList();
    }
    await db.close();
    return temp;
  }

//  int id;
//  String link;
//  String name;
//  int order;
//  int visible;
  //批量增、改、删数据
  static Future<void> batch(List<HotWordModel> list) async {
    if(!isValidList(list)){
      return Future;
    }
    Database db = await open();
    var batch = db.batch();
    list.forEach((pm){
      Map map= {
        'id':pm.id,
        'name':pm.name,
        'link':pm.link,
        'order':pm.order,
        'visible':pm.visible,
      };
      batch.insert(tablename,map);
    });
    //返回每个数据库操作的结果组成的数组 [6, 3, 0]：新增返回id=6，修改了3条数据，删除了0条数据
    var results = await batch.commit();
    return db.close();
  }
}