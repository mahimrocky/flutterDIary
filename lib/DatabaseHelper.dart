import 'dart:async';
import 'dart:io';
import 'package:flutter_diary/homeScreen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  final String dbName = "HelloDiary.db";
  static final String tableName = "Diary";

  static final String idColumn = "id";
  static final String titleColumn = "title";
  static final String contentColumn = "content";
  static final String timeColumn = "time";

  String create_table = "CREATE TABLE " +
      tableName +
      " (" +
      idColumn +
      " INTEGER PRIMARY KEY AUTOINCREMENT, " +
      titleColumn +
      " TEXT, " +
      contentColumn +
      " TEXT, " +
      timeColumn +
      " TEXT)";

  Database database;

  bool isDatabaseInit = false;

  static final DatabaseHelper databaseHelper = new DatabaseHelper.internal();

 static DatabaseHelper get() {
    return databaseHelper;
  }

  DatabaseHelper.internal();

  Future<Database> getDb() async {
    if (!isDatabaseInit) {
      await DBinit();
    }
    return database;
  }

  Future DBinit() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, dbName);

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
      db.execute(create_table);
      isDatabaseInit = true;
    });
  }

  Future insertOrReplace(DiaryModel model) async {
    var db = await getDb();
    String sql = "INSERT OR REPLACE INTO " +
        tableName +
        " (" +
        titleColumn +
        "," +
        contentColumn +
        "," +
        timeColumn +
        ") VALUES (?,?,?)";
    await db.rawInsert(sql, [model.title, model.content, model.time]);
  }

  /*
  * Get all list of data. With Future model. Then we have to parse the actual list
  * */

  Future<List<DiaryModel>> getAllContent() async {
    var db = await getDb();
    String sql = "SELECT * FROM " + tableName;
    var result = await db.rawQuery(sql);

    List<DiaryModel> diaryList = [];

    for (Map<String, dynamic> item in result) {

      DiaryModel model = new DiaryModel(
          item[titleColumn], item[contentColumn], item[timeColumn]);
      model.id = item[idColumn];

      diaryList.add(model);
    }
    return diaryList;
  }

  /*
  * Delete specific item
  * */

  Future<int> deleteItem(int id) async{
    var db = await getDb();
    String sql = "DELETE FROM "+tableName+" WHERE "+idColumn+" = ?";
    var result = db.rawDelete(sql,[id]);

    return result;
  }
}
