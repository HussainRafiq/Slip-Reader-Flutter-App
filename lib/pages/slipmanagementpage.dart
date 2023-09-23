import 'package:flutter/material.dart';
import 'package:slip_readerv2/Database/Model/CustomerModel.dart';
import 'package:slip_readerv2/Database/Model/SlipModel.dart';
import 'package:slip_readerv2/pages/homepage.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slip_readerv2/pages/multislippage.dart';
import 'package:slip_readerv2/pages/slippage.dart';
import 'package:splashscreen/splashscreen.dart';

class SlipManagementPage extends StatefulWidget {
  const SlipManagementPage({Key? key}) : super(key: key);
  @override
  _SlipManagementPageState createState() => new _SlipManagementPageState();
}

class _SlipManagementPageState extends State<SlipManagementPage> {
  List<SlipModel>? slips;
  List<CustomerModel>? customers;
  List<SlipModel?> _selectedSlip = [];
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
        title: Text("Slips Management"),
        elevation: 0,
      ),
      body: Column(
        children: [
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
                                leading: Checkbox(
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedSlip.add(slips?[index]);
                                      } else {
                                        _selectedSlip.removeWhere((element) =>
                                            element?.ID == slips?[index].ID);
                                      }
                                    });
                                  },
                                  value: _selectedSlip.any((element) =>
                                      element?.ID == slips?[index].ID),
                                ),
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
                                    Wrap(
                                      children: [
                                        Text(
                                          "Customer : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          slips?[index].customer?.Name ?? "",
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
          _selectedSlip.length > 0
              ? Container(
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
                      child: Text("${_selectedSlip.length}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, onPrimary: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiSlipPage(
                                    slips: _selectedSlip.toList(),
                                  )),
                        );
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
                              "Go To Slips",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected Slips",
                          maxLines: 3,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ))
              : Container(),
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

  getallSlips() async {
    var _customers = await CustomerModel().get();
    var _slips = await SlipModel().getAllSlips();
    setState(() {
      slips = _slips;
      customers = _customers;
      slips?.sort((a, b) =>
          (b.CreatedDate?.compareTo(a.CreatedDate ?? DateTime(2022))) ?? 0);

      slips?.forEach((element) {
        var _c = _customers.where((k) => k.ID == element.CustomerKey);
        element.customer = _c.length > 0 ? _c.first : null;
      });
    });
  }
}
