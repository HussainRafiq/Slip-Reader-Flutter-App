import 'package:flutter/material.dart';
import 'package:slip_readerv2/Database/Model/CustomerModel.dart';
import 'package:slip_readerv2/Database/Model/SlipModel.dart';
import 'package:slip_readerv2/pages/homepage.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slip_readerv2/pages/slippage.dart';
import 'package:splashscreen/splashscreen.dart';

class CustomerPersonalPage extends StatefulWidget {
  final CustomerModel customer;

  const CustomerPersonalPage({Key? key, required this.customer})
      : super(key: key);
  @override
  _CustomerPersonalPageState createState() => new _CustomerPersonalPageState();
}

class _CustomerPersonalPageState extends State<CustomerPersonalPage> {
  List<SlipModel>? slips;

  @override
  initState() {
    super.initState();
    getallSlips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Customer Profile"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Icon(Icons.person, color: Colors.black, size: 50),
                ),
                trailing: Wrap(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        update(widget.customer.ID);
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.customer.Name ?? "",
                      maxLines: 3,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    Text(
                      widget.customer.Address ?? "",
                      maxLines: 3,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              )),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2.0,
                ),
              ],
            ),
            margin: EdgeInsets.all(10),
            child: slips == null
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
                : slips?.length == 0
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
                                style:
                                    TextStyle(fontSize: 25, color: Colors.grey),
                              )
                            ]),
                      )
                    : ListView(
                        children: List.generate(
                          (slips?.length) ?? 0,
                          (index) => Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SlipPage(
                                              slip: slips?[index] ?? null,
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
                                        addSlip(slips?[index].ID);
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
                                        deleteSlip(slips?[index].ID);
                                      },
                                    ),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      children: [
                                        Text(
                                          "Slip No : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          slips?[index].SlipNo ?? "",
                                        )
                                      ],
                                    ),
                                    Text(
                                      slips?[index].Name ?? "",
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Wrap(
                                      children: [
                                        Text(
                                          "Created At : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          DateFormat.yMMMEd().format(
                                              slips?[index].CreatedDate ??
                                                  new DateTime(2002)),
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
          )),
          Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Text("${slips?.length ?? 0}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black, onPrimary: Colors.grey),
                  onPressed: () {
                    addSlip(null);
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
                          "Add New Slip",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Slips",
                      maxLines: 3,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  deleteSlip(ID) {
    if (ID != null && ID > 0) {
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
                    var isDeleteSlip = await SlipModel().delete(ID);
                    Navigator.pop(context);
                    if (isDeleteSlip) {
                      getallSlips();
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

  // getDescFromJSON(_json) {
  //   Map<String, dynamic> extra = json.decode(_json);
  //   if (extra.containsKey("Desc")) {
  //     return extra["Desc"];
  //   }

  //   return "";
  // }

  update(CustomerCode) async {
    if (CustomerCode != null && CustomerCode != 0) {
      var cstomer = widget.customer;

      TextEditingController _Ntext = TextEditingController(text: cstomer.Name);
      TextEditingController _Addresstext =
          TextEditingController(text: cstomer.Address);
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
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  child: Text('Save'),
                  onPressed: () async {
                    var CustomerCode = cstomer.ID;
                    var name = _Ntext.text;
                    var address = _Addresstext.text;

                    var Customer = CustomerModel(
                        ID: CustomerCode, Name: name, Address: address);

                    var isUpdate = (await Customer.update());

                    Navigator.pop(context);
                    if (isUpdate) {
                      setState(() {
                        widget.customer.Name = Customer.Name;
                        widget.customer.Address = Customer.Address;
                      });
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

  addSlip(int? id) async {
    TextEditingController _Ntext = TextEditingController();
    TextEditingController _SlipNotext = TextEditingController();
    SlipModel? slip = null;
    if (id != null) {
      var slips = await SlipModel().getByID(id);

      if (slips != null && slips.length > 0) {
        slip = slips.first;
      }
    }
    if (slip != null) {
      _Ntext.text = slip.Name ?? "";
      _SlipNotext.text = slip.SlipNo ?? "";
    }

    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add New Slip'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: _SlipNotext,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a Slip No',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _Ntext,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a Slip Title',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text('Save'),
                onPressed: () async {
                  if (_SlipNotext.text.isEmpty || _Ntext.text.isEmpty) {
                    return;
                  }
                  if (slips != null &&
                      slips?.any((element) =>
                              element.SlipNo == _SlipNotext.text) ==
                          true) {
                    Fluttertoast.showToast(
                        msg: "Slip already added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }
                  var slipCode = _SlipNotext.text;
                  var name = _Ntext.text;

                  var item = SlipModel(
                      ID: slip != null ? slip.ID : null,
                      CustomerKey: widget.customer.ID,
                      SlipNo: slipCode,
                      Name: name);
                  if (slip == null) {
                    var isAdd = await item.insert();
                    if (isAdd) {
                      Fluttertoast.showToast(
                          msg: "Slip added successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      getallSlips();
                      Navigator.pop(context);
                    }
                  } else {
                    var isAdd = await item.update();
                    if (isAdd) {
                      Fluttertoast.showToast(
                          msg: "Slip updated successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      getallSlips();
                      Navigator.pop(context);
                    }
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

  getallSlips() async {
    var _slips = await SlipModel().get(widget.customer.ID);
    setState(() {
      slips = _slips;
      slips?.sort((a, b) =>
          (b.CreatedDate?.compareTo(a.CreatedDate ?? DateTime(2022))) ?? 0);
    });
  }
}
