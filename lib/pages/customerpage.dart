import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:slip_readerv2/Database/Model/CustomerModel.dart';
import 'package:slip_readerv2/pages/customerpersonalpage.dart';
import 'package:slip_readerv2/pages/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splashscreen/splashscreen.dart';

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => new _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  TextEditingController Ntext = TextEditingController();
  TextEditingController Addresstext = TextEditingController();
  TextEditingController Sequencetext = TextEditingController();
  List<CustomerModel>? Customers;
  bool isAddModelShow = false;
  @override
  initState() {
    super.initState();

    //_initSP();
    //cartCustomers = [];
    getAllCustomers();

    //getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Management"), actions: [
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
                  "Add New Customer",
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
                                  "Add Customer Details",
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
                            controller: Ntext,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a Customer Name',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: Addresstext,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a Customer Address',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: Sequencetext,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a Item Sequence',
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
                child: Customers == null
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
                    : Customers?.length == 0
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
                            (Customers?.length) ?? 0,
                            (index) => Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerPersonalPage(
                                                customer: Customers?[index]
                                                    as CustomerModel,
                                              )),
                                    );
                                  },
                                  trailing: Wrap(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blueGrey,
                                        ),
                                        onPressed: () {
                                          update(Customers?[index].ID);
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
                                          delete(Customers?[index].ID);
                                        },
                                      ),
                                    ],
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Customers?[index].Name ?? "",
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        Customers?[index].Address ?? "",
                                        maxLines: 3,
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 15),
                                      ),
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

  // getDescFromJSON(_json) {
  //   Map<String, dynamic> extra = json.decode(_json);
  //   if (extra.containsKey("Desc")) {
  //     return extra["Desc"];
  //   }

  //   return "";
  // }
  isItemSequenceVerified(pSequencetext) {
    bool isVerified = true;

    List<String> items_Seq = pSequencetext.text.split(",");
    items_Seq = items_Seq.where((e) => e != '').toList();
    print(isVerified);
    if (items_Seq.length > 0) {
      print(items_Seq.length);
      items_Seq.forEach((element) {
        if (int.tryParse(element) == null) {
          isVerified = false;
        }
      });
    }
    if (!isVerified) {
      Fluttertoast.showToast(
          msg: "Item Sequence is not correct format",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return isVerified;
  }

  add() async {
    if (Addresstext.text.isEmpty &&
        Ntext.text.isEmpty &&
        !isItemSequenceVerified(Sequencetext)) {
      return;
    }

    var name = Ntext.text;
    var address = Addresstext.text;
    var sequence = Sequencetext.text.split(",");

    var Customer = CustomerModel(
        Name: name,
        Address: address,
        Extra: json.encode({"Sequence": sequence}));
    var isAdd = await Customer.insert();
    if (isAdd) {
      clear();
      getAllCustomers();
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

  delete(CustomerCode) async {
    if (CustomerCode != null && CustomerCode != 0) {
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
                    var isdDeleteCustomer =
                        await CustomerModel().delete(CustomerCode);
                    Navigator.pop(context);
                    if (isdDeleteCustomer) {
                      getAllCustomers();
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

  update(CustomerCode) async {
    if (CustomerCode != null && CustomerCode != 0) {
      var Customerlit =
          Customers?.where((element) => element.ID == CustomerCode);

      if (Customerlit?.length == 0) return;

      var cstomer = Customerlit?.first;

      String sequence = '';
      try {
        if ((cstomer?.Extra ?? "").isNotEmpty &&
            json.decode(cstomer?.Extra ?? "")["Sequence"] != null) {
          sequence =
              (json.decode(cstomer?.Extra ?? "")["Sequence"] as List).join(",");
        }
      } catch (ex) {}
      ;

      TextEditingController _Ntext = TextEditingController(text: cstomer?.Name);
      TextEditingController _Addresstext =
          TextEditingController(text: cstomer?.Address);
      TextEditingController _Sequencetext =
          TextEditingController(text: sequence);
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Customer'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _Ntext,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a Customer Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _Addresstext,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a Customer Address',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _Sequencetext,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a Item Sequence',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text('Save'),
                  onPressed: () async {
                    if (!isItemSequenceVerified(_Sequencetext)) return;

                    var CustomerCode = cstomer?.ID;
                    var name = _Ntext.text;
                    var address = _Addresstext.text;
                    var sequence = _Sequencetext.text.split(",");

                    var Customer = CustomerModel(
                        ID: CustomerCode,
                        Name: name,
                        Address: address,
                        Extra: json.encode({"Sequence": sequence}));

                    var isUpdate = (await Customer.update());

                    Navigator.pop(context);
                    if (isUpdate) {
                      getAllCustomers();
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
    Ntext.clear();
    Addresstext.clear();
    Sequencetext.clear();
  }

  getAllCustomers() async {
    var _Customers = await CustomerModel().get();

    setState(() {
      Customers = _Customers;
    });
  }
}
