import 'dart:convert';

import 'package:slip_readerv2/Database/Model/CustomerModel.dart';
import 'package:slip_readerv2/Database/database.dart';
import 'package:sqflite/sqflite.dart';

class SlipModel {
  int? ID;
  String? SlipNo;
  String? Name;
  int? CustomerKey;
  DateTime? CreatedDate;
  CustomerModel? customer;
  SlipModel(
      {this.ID,
      this.SlipNo,
      this.Name,
      this.CustomerKey,
      this.CreatedDate,
      this.customer});

  Future<bool> insert() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count = await txn.rawUpdate(
          "INSERT INTO Slip(CustomerKey, SlipNo, Name, Date) VALUES(?, ?, ?, DATE('now'))",
          [CustomerKey, SlipNo, Name]);
      return count > 0;
    });
  }

  Future<bool> update() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count = await txn.rawUpdate(
          'update Slip set SlipNo=?,Name=? where _id=?', [SlipNo, Name, ID]);
      return count > 0;
    });
  }

  Future<bool> delete(_ID) async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count = await txn.rawDelete('DELETE FROM Slip WHERE _id=?', [_ID]);
      return count > 0;
    });
  }

  Future<List<SlipModel>> getByID(_ID) async {
    var db = await initDb();
    return await db.transaction((txn) async {
      var dict = await txn.rawQuery('Select * FROM Slip WHERE _id=?', [_ID]);
      List<SlipModel> list = [];
      dict.forEach((element) {
        list.add(new SlipModel(
            ID: int.parse(element["_id"].toString()),
            SlipNo: element["SlipNo"].toString(),
            Name: element["Name"].toString(),
            CustomerKey: int.parse(element["CustomerKey"].toString()),
            CreatedDate: DateTime.parse(element["Date"].toString())));
      });
      return list;
    });
  }

  Future<List<SlipModel>> get(customerKey) async {
    var db = await initDb();
    return await db.transaction((txn) async {
      var dict = await txn
          .rawQuery('Select * FROM Slip where customerkey=$customerKey');
      List<SlipModel> list = [];
      dict.forEach((element) {
        list.add(new SlipModel(
            ID: int.parse(element["_id"].toString()),
            SlipNo: element["SlipNo"].toString(),
            Name: element["Name"].toString(),
            CustomerKey: int.parse(element["CustomerKey"].toString()),
            CreatedDate: DateTime.parse(element["Date"].toString())));
      });
      return list;
    });
  }

  Future<List<SlipModel>> getAllSlips() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      var dict = await txn.rawQuery('Select * FROM Slip');
      List<SlipModel> list = [];
      dict.forEach((element) {
        list.add(new SlipModel(
            ID: int.parse(element["_id"].toString()),
            SlipNo: element["SlipNo"].toString(),
            Name: element["Name"].toString(),
            CustomerKey: int.parse(element["CustomerKey"].toString()),
            CreatedDate: DateTime.parse(element["Date"].toString())));
      });
      return list;
    });
  }
}
