import 'package:flutter/material.dart';
import 'package:slip_readerv2/pages/itempage.dart';
import 'package:slip_readerv2/pages/slipmanagementpage.dart';
import 'package:splashscreen/splashscreen.dart';

import 'customerpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Receipt Loud Reader',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
        ),
        body: Column(children: [
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      color: Colors.blueGrey,
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Container(
                      height: 100,
                      child: Row(
                        children: [
                          Image.asset("assets/img.png"),
                          Flexible(
                            child: Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Receipt Loud Reader",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "-- With Management Of Customer\n-- With Management Of Previous Receipt Records\n-- With Management Of Specific Sequence Of Each Customer",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10.0,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height - 225,
              child: ListView(
                padding: EdgeInsets.all(15),
                children: [
                  Wrap(
                    children: [
                      Container(
                        width: ((MediaQuery.of(context).size.width - 30) / 2),
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        color: Colors.transparent,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.blueGrey),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerPage()),
                            );
                          },
                          child: Container(
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/customer.png", height: 80),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Manage Customers",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: ((MediaQuery.of(context).size.width - 30) / 2),
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        color: Colors.transparent,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.blueGrey),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SlipManagementPage()),
                            );
                          },
                          child: Container(
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/receipt.png", height: 80),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Manage Receipts",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   width: ((MediaQuery.of(context).size.width - 30) / 2),
                      //   padding:
                      //       EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      //   color: Colors.transparent,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Colors.white,
                      //       onPrimary: Colors.blueGrey,
                      //     ),
                      //     onPressed: () {},
                      //     child: Container(
                      //       height: 150,
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Image.asset("assets/favourite.png", height: 80),
                      //           SizedBox(
                      //             height: 5,
                      //           ),
                      //           Text(
                      //             "Favourite Receipts",
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //                 color: Colors.blueGrey, fontSize: 18),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        width: ((MediaQuery.of(context).size.width - 30) / 2),
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        color: Colors.transparent,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.blueGrey),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemPage()),
                            );
                          },
                          child: Container(
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/item.png", height: 80),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Manage Items",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ))
        ]));
  }
}
