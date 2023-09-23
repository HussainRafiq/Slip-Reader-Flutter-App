import 'dart:convert';

import 'package:slip_readerv2/Database/database.dart';
import 'package:sqflite/sqflite.dart';

class ItemModel {
  String? ItemCode;
  String? Name;
  String? Extra;
  ItemModel({this.ItemCode, this.Name, this.Extra}) {}

  Future<void> addALL() async {}

  Future<bool> insert() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count = await txn.rawUpdate(
          'INSERT INTO Item(ItemCode, Name, Extra) VALUES(?, ?, ?)',
          [ItemCode, Name, Extra]);
      return count > 0;
    });
  }

  Future<bool> delete() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count =
          await txn.rawDelete('DELETE FROM Item WHERE ItemCode=?', [ItemCode]);
      return count > 0;
    });
  }

  Future<List<ItemModel>> getByID(_ItemCode) async {
    var db = await initDb();
    return await db.transaction((txn) async {
      var dict =
          await txn.rawQuery('Select * FROM Item WHERE ItemCode=?', [ItemCode]);
      List<ItemModel> list = [];
      dict.forEach((element) {
        list.add(new ItemModel(
            ItemCode: element["ItemCode"].toString(),
            Name: element["Name"].toString(),
            Extra: json.decode(element["Extra"].toString())));
      });
      return list;
    });
  }

  Future<List<ItemModel>> get() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      var dict = await txn.rawQuery('Select * FROM Item');
      List<ItemModel> list = [];
      dict.forEach((element) {
        list.add(new ItemModel(
            ItemCode: element["ItemCode"].toString(),
            Name: element["Name"].toString(),
            Extra: element["Extra"].toString()));
      });
      return list;
    });
  }
}
