import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

String dbName="defaultDB";


//创建数据库
Future<String> _createNewDb(String dbName) async {
  //获取数据库文件路径
  var dbPath = await getDatabasesPath();
  print('dbPath:' + dbPath);

  String path = join(dbPath, dbName);

  if (await databaseExists(path)) {
    print('db已经存在;' + dbPath);
  } else {
    try {
      await new Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
  }
  return path;
}

Future<void> create(String sqlCreateTable) async {
  String dbPath = await _createNewDb(dbName);
  Database db = await openDatabase(dbPath);

  await db.execute(sqlCreateTable);
  return db.close();
}

//打开数据库，获取数据库对象
Future<Database> open() async {
  String dbPath;
  if(null == dbPath){
    var path = await getDatabasesPath();
    dbPath = join(path, dbName);
    print('dbPath:' + dbPath);
  }
  return openDatabase(dbPath);
}
