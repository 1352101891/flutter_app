
import 'package:flutter_app/model/PaperModel.dart';
import 'package:flutter_app/util/Util.dart';
import 'package:sqflite/sqflite.dart';
import 'DBHelper.dart';
class DBOperationArticle{
  static String tablename="PaperModel";
  static String createPaperTableSql=
      "CREATE TABLE  if not exists PaperModel ("
      "id int,"
      "originId int,"
      "title varchar(255),"
      "link varchar(255),"
      "niceDate varchar(100),"
      "author varchar(50))" ;

  static Future<int> addNotMuti(PaperModel pm) async {
    if(pm.originId==null){
      pm.originId=0;
    }
    Database db = await open();

    String sql =
        "INSERT INTO "+tablename+"  VALUES('${pm.id}','${pm.originId}','${pm.title}','${pm.link}','${pm.niceDate}','${pm.author}')";
    return db.rawInsert(sql,null);
  }

  static Future<int> add(PaperModel pm) async {
    if(pm.originId==null){
      pm.originId=0;
    }

    Database db = await open();

    String sql =
        "INSERT INTO "+tablename+"  VALUES('${pm.id}','${pm.originId}','${pm.title}','${pm.link}','${pm.niceDate}','${pm.author}')";
    //开启事务
    return db.rawInsert(sql,null);
  }

  static Future<void> delete(PaperModel pm) async {
    Database db = await open();

    //删除最近一条
    String sql = "DELETE FROM "+tablename+"  where id = ${pm.id}";
    int count = await db.rawDelete(sql);

    return db.close();
  }

  static Future<void> update(PaperModel pm) async {
    Database db = await open();
    await delete(pm);
    await add(pm);
    return db.close();
  }

  static Future<int> queryNumByCon(PaperModel pm) async {
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

  static Future<List<PaperModel>>  queryByPageno(int pageno) async {
    List<PaperModel> temp=new List();
    Database db = await open();
    List<Map> list = await db.rawQuery("select * from  "+tablename+"  limit 10 offset "+ (pageno*10).toString());
    if(isValidList(list)){
      temp=list.map((f){
        PaperModel paperModel=new PaperModel.fromJson(f);
        return paperModel;
      }).toList();
    }
    await db.close();
    return temp;
  }


  Future<List<PaperModel>>  query() async {
    List<PaperModel> temp=new List();
    Database db = await open();
    List<Map> list = await db.rawQuery("select * from  "+tablename);
    if(isValidList(list)){
      temp=list.map((f){
        PaperModel paperModel=new PaperModel.fromJson(f);
        return paperModel;
      }).toList();
    }
    await db.close();
    return temp;
  }


  //批量增、改、删数据
  batch() async {
    Database db = await open();
    var batch = db.batch();
    batch.insert("user_table", {"username": "batchName1"});
    batch.update("user_table", {"username": "batchName2"}, where: "username = ?",whereArgs: ["batchName1"]);
    batch.delete("user_table", where: "username = ?", whereArgs: ["Leon"]);
    //返回每个数据库操作的结果组成的数组 [6, 3, 0]：新增返回id=6，修改了3条数据，删除了0条数据
    var results = await batch.commit();
    await db.close();
  }
}