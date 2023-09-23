import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:slip_readerv2/Database/Model/ItemModel.dart';
import 'package:slip_readerv2/pages/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splashscreen/splashscreen.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => new _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  TextEditingController ICtext = TextEditingController();
  TextEditingController Ntext = TextEditingController();
  TextEditingController Desctext = TextEditingController();
  List<ItemModel>? items;
  bool isAddModelShow = false;
  @override
  initState() {
    super.initState();

    //_initSP();
    //cartItems = [];
    getAllItems();

    //getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Item Management"), actions: [
        !isAddModelShow
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, onPrimary: Colors.grey),
                onPressed: () {
                  setState(() {
                    isAddModelShow = true;
                  });
                },
                child: Container(
                    child: Text(
                  "Add New Item",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )),
              )
            : SizedBox(),
      ]),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              !isAddModelShow
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width - 30,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Add Item Details",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isAddModelShow = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          TextField(
                            controller: ICtext,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a Item Code',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: Ntext,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a Item Name',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: Desctext,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a Item Description',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey,
                                    onPrimary: Colors.grey),
                                onPressed: () {
                                  add();
                                },
                                child: Container(
                                  child: Wrap(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Add",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    onPrimary: Colors.white),
                                onPressed: () {
                                  clear();
                                },
                                child: Container(
                                  child: Wrap(
                                    children: [
                                      Icon(Icons.clear),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Clear",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                          ),
                        ],
                      )),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: items == null
                    ? Center(
                        child: Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Please Wait...",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ]),
                      )
                    : items?.length == 0
                        ? Center(
                            child: Wrap(
                                direction: Axis.vertical,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/notfound.png",
                                    width: 150,
                                  ),
                                  Text(
                                    "No Data Found",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.grey),
                                  )
                                ]),
                          )
                        : ListView(
                            children: List.generate(
                            (items?.length) ?? 0,
                            (index) => Column(
                              children: [
                                ListTile(
                                  trailing: Wrap(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blueGrey,
                                        ),
                                        onPressed: () {
                                          update(items?[index].ItemCode);
                                        },
                                        padding: EdgeInsets.zero,
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          delete(items?[index].ItemCode);
                                        },
                                      ),
                                    ],
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items?[index].ItemCode ?? "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        items?[index].Name ?? "",
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      getDescFromJSON(items?[index].Extra) != ''
                                          ? Text(
                                              getDescFromJSON(
                                                  items?[index].Extra),
                                              maxLines: 3,
                                              style: TextStyle(fontSize: 15),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                Divider()
                              ],
                            ),
                          )),
              ))
            ],
          )),
    );
  }

  getDescFromJSON(_json) {
    Map<String, dynamic> extra =
        _json != null && _json != "" ? json.decode(_json) : null;
    if (extra != null && extra.containsKey("Desc")) {
      return extra["Desc"];
    }

    return "";
  }

  add() async {
    if (ICtext.text.isEmpty || Ntext.text.isEmpty) {
      return;
    }
    if (items?.any((element) => element.ItemCode == ICtext.text) == true) {
      Fluttertoast.showToast(
          msg: "ItemCode already added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    var itemCode = ICtext.text;
    var name = Ntext.text;
    var desc = Desctext.text;

    var item = ItemModel(
        ItemCode: itemCode, Name: name, Extra: json.encode({"Desc": desc}));
    var isAdd = await item.insert();
    if (isAdd) {
      clear();
      getAllItems();
      Fluttertoast.showToast(
          msg: "Added Succesfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Some Error Occurred",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  delete(itemCode) async {
    if (itemCode != '') {
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Are you Sure To Delete ?'),
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text('Yes'),
                  onPressed: () async {
                    var isdDeleteitem =
                        await ItemModel(ItemCode: itemCode).delete();
                    Navigator.pop(context);
                    if (isdDeleteitem) {
                      getAllItems();
                      Fluttertoast.showToast(
                          msg: "Deleted Succesfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Some Error Occurred",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                ),
                RaisedButton(
                  child: Text('No'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  update(itemCode) async {
    if (itemCode != '') {
      var itemlit = items?.where((element) => element.ItemCode == itemCode);
      print(itemlit);
      if (itemlit?.length == 0) return;

      var item = itemlit?.first;

      TextEditingController _ICtext =
          TextEditingController(text: item?.ItemCode);
      TextEditingController _Ntext = TextEditingController(text: item?.Name);
      TextEditingController _Desctext =
          TextEditingController(text: getDescFromJSON(item?.Extra));
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Item'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: _ICtext,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a Item Code',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _Ntext,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a Item Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _Desctext,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a Item Description',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text('Save'),
                  onPressed: () async {
                    var itemCode = _ICtext.text;
                    var name = _Ntext.text;
                    var desc = _Desctext.text;
                    var isdDeleteitem =
                        await ItemModel(ItemCode: itemCode).delete();
                    var item = ItemModel(
                        ItemCode: itemCode,
                        Name: name,
                        Extra: json.encode({"Desc": desc}));

                    var isUpdate =
                        isdDeleteitem ? (await item.insert()) : false;

                    Navigator.pop(context);
                    if (isUpdate) {
                      getAllItems();
                      Fluttertoast.showToast(
                          msg: "Updated Succesfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Some Error Occurred",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                ),
                RaisedButton(
                  child: Text('Cancel'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  clear() {
    ICtext.clear();
    Ntext.clear();
    Desctext.clear();
  }

  getAllItems() async {
    var _items = await ItemModel().get();
    setState(() {
      items = _items;
    });
  }
}
