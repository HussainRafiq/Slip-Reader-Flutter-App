import 'dart:convert';

import 'package:slip_readerv2/Database/database.dart';
import 'package:sqflite/sqflite.dart';

class CustomerModel {
  int? ID;
  String? Name;
  String? Address;
  String? Extra;
  CustomerModel({this.ID, this.Name, this.Address, this.Extra});

  Future<bool> insert() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count = await txn.rawUpdate(
          'INSERT INTO Customer(Name,Address, Extra) VALUES(?, ?, ?)',
          [Name, Address, Extra]);
      return count > 0;
    });
  }

  Future<bool> update() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count = await txn.rawUpdate(
          'update Customer set Name=?,Address=?, Extra=? where _id=?',
          [Name, Address, Extra, ID]);
      return count > 0;
    });
  }

  Future<bool> delete(_ID) async {
    var db = await initDb();
    return await db.transaction((txn) async {
      int count =
          await txn.rawDelete('DELETE FROM Customer WHERE _id=?', [_ID]);
      return count > 0;
    });
  }

  Future<List<CustomerModel>> getByID(_ID) async {
    var db = await initDb();
    return await db.transaction((txn) async {
      var dict =
          await txn.rawQuery('Select * FROM Customer WHERE _id=?', [_ID]);
      List<CustomerModel> list = [];
      dict.forEach((element) {
        list.add(new CustomerModel(
            ID: int.parse(element["_id"].toString()),
            Name: element["Name"].toString(),
            Address: element["Address"].toString(),
            Extra: element["Extra"].toString()));
      });
      return list;
    });
  }

  Future<List<CustomerModel>> get() async {
    var db = await initDb();
    return await db.transaction((txn) async {
      var dict = await txn.rawQuery('Select * FROM Customer');
      List<CustomerModel> list = [];
      dict.forEach((element) {
        list.add(new CustomerModel(
            ID: int.parse(element["_id"].toString()),
            Name: element["Name"].toString(),
            Address: element["Address"].toString(),
            Extra: element["Extra"].toString()));
      });
      return list;
    });
  }
}
