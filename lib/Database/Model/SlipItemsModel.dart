import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slip_readerv2/Database/Model/ItemModel.dart';
import 'package:slip_readerv2/Database/database.dart';
import 'package:sqflite/sqflite.dart';

class SlipItemsModel {
  int? ID;
  int? ItemCode;
  int? SlipKey;
  int? Qty;
  ItemModel? Item;
  SlipItemsModel({this.ID, this.ItemCode, this.SlipKey, this.Qty, this.Item}) {}

  Future<bool> insert() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count = await txn.rawUpdate(
          'INSERT INTO SlipItems(SlipKey,ItemCode, Qty) VALUES(?, ?, ?)',
          [SlipKey, ItemCode, Qty]);
      return count > 0;
    });
  }

  Future<List<SlipItemsModel>> insertAll(
      List<SlipItemsModel> list, slipKey) async {
    if (list != null && list.length > 0) {
      var db = await initDb();
      await db.transaction((txn) async {
        var query = 'DELETE From SlipItems WHERE SlipKey=$slipKey';
        await txn.rawUpdate(query);
      });
      list.forEach((element) async {
        element.SlipKey = slipKey;
        await element.insert();
      });
      return await get(slipKey);

      //   var db = await initDb();
      //   // await db.transaction((txn) async {
      //   //   var query = 'DELETE From SlipItems WHERE SlipKey=$slipKey';
      //   //   await txn.rawUpdate(query, [SlipKey, ItemCode, Qty]);
      //   // });
      //   var query = 'INSERT INTO SlipItems(SlipKey,ItemCode, Qty) VALUES';
      //   var listOfQuery = [];
      //   list.forEach((element) {
      //     listOfQuery.add("($slipKey,${element.ItemCode},${element.Qty})");
      //   });
      //   query += listOfQuery.join(",");
      //   Fluttertoast.showToast(
      //       msg: "$query",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.blueGrey,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      //   print(query);

      //   return await db.transaction((txn) async {
      //     int count = await txn.rawUpdate(query, [SlipKey, ItemCode, Qty]);
      //     return count > 0 ? await get(slipKey) : List.empty();
      //   });
    } else {
      return new List.empty();
    }
  }

  Future<bool> delete() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count =
          await txn.rawDelete('DELETE FROM SlipItems WHERE _id=?', [ID]);
      return count > 0;
    });
  }

  Future<List<SlipItemsModel>> getByID(ID) async {
    var db = await initDb();
    return await db.transaction((txn) async {
      var dict =
          await txn.rawQuery('Select * FROM SlipItems WHERE _id=?', [ID]);
      List<SlipItemsModel> list = [];
      dict.forEach((element) {
        list.add(new SlipItemsModel(
            ItemCode: int.parse(element["ItemCode"].toString()),
            ID: int.parse(element["_id"].toString()),
            Qty: int.parse(element["Qty"].toString()),
            SlipKey: int.parse(element["SlipKey"].toString())));
      });
      return list;
    });
  }

  Future<List<SlipItemsModel>> get(slipkey) async {
    var db = await initDb();
    return await db.transaction((txn) async {
      var dict =
          await txn.rawQuery('Select * FROM SlipItems where SlipKey=$slipkey');
      List<SlipItemsModel> list = [];
      dict.forEach((element) {
        list.add(new SlipItemsModel(
            ItemCode: int.parse(element["ItemCode"].toString()),
            ID: int.parse(element["_id"].toString()),
            Qty: int.parse(element["Qty"].toString()),
            SlipKey: int.parse(element["SlipKey"].toString())));
      });
      return list;
    });
  }
}
