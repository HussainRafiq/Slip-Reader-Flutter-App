import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:slip_readerv2/Database/Model/CustomerModel.dart';
import 'package:slip_readerv2/Database/Model/ItemModel.dart';
import 'package:slip_readerv2/Database/Model/SlipItemsModel.dart';
import 'package:slip_readerv2/Database/Model/SlipModel.dart';
import 'package:slip_readerv2/pages/homepage.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SlipPage extends StatefulWidget {
  final SlipModel? slip;

  const SlipPage({Key? key, required this.slip}) : super(key: key);
  @override
  _SlipPageState createState() => new _SlipPageState();
}

class _SlipPageState extends State<SlipPage> {
  CustomerModel? customer;
  List<SlipItemsModel> slipItems = [];
  bool isEditMode = true, isLoading = false;
  List<ItemModel> items = [];
  FlutterTts flutterTts = FlutterTts();
  bool _speechEnabled = false;
  int currentPlayIndex = -1;
  bool isEnd = false;
  SpeechToText _speechToText = SpeechToText();
  @override
  initState() {
    super.initState();

    CustomerModel().getByID(widget.slip?.CustomerKey ?? 0).then((customers) {
      if (customers.length > 0)
        setState(() {
          customer = customers.first;
        });
    });
    getData();
  }

  Future<void> getData() async {
    await flutterTts.setSharedInstance(true);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.2);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    flutterTts.setCompletionHandler(() {
      setState(() {
        currentPlayIndex = -1;
        isEnd = true;
      });
    });

    items = await ItemModel().get();
    SlipItemsModel().get(widget.slip?.ID ?? 0).then((value) {
      if (value != null && value.length > 0) {
        setState(() {
          slipItems = makeItemAdd(value);
          isEditMode = false;
        });
      }
    });
    _speechEnabled = await _speechToText.initialize();

    setState(() {});
  }

  List<SlipItemsModel> makeItemAdd(List<SlipItemsModel> list) {
    List<SlipItemsModel> nlist = [];
    if (items.length > 0) {
      list.forEach((element) {
        var _items =
            items.where((k) => k.ItemCode == element.ItemCode.toString());
        if (_items != null && _items.length > 0) {
          element.Item = _items.first;
          nlist.add(element);
        } else {
          element.Item = ItemModel(Name: "Unknown");
          nlist.add(element);
        }
      });
    }
    return MakeInSequence(nlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.slip?.Name ?? ""),
        elevation: 0,
      ),
      floatingActionButton: isLoading
          ? Container()
          : isEditMode
              ? Wrap(
                  direction: Axis.horizontal,
                  children: [
                    slipItems.any((e) => e.ID == null)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black, onPrimary: Colors.grey),
                            onPressed: () {
                              save();
                            },
                            child: Container(
                                child: Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            )),
                          )
                        : SizedBox(),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, onPrimary: Colors.grey),
                      onPressed: () {
                        addOrUpdateSlipItem(null);
                      },
                      child: Container(
                          child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Text(
                            "Add Item",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, onPrimary: Colors.grey),
                      onPressed: () {
                        scanSlip();
                      },
                      child: Container(
                          child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Icon(
                            Icons.scanner_sharp,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Scan To Manage Items",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      )),
                    ),
                  ],
                )
              : Wrap(
                  direction: Axis.horizontal,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, onPrimary: Colors.grey),
                      onPressed: () {
                        flutterTts.stop();
                        setState(() {
                          currentPlayIndex = -1;
                          isEditMode = true;
                        });
                      },
                      child: Container(
                          child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Text(
                            "Edit",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, onPrimary: Colors.grey),
                      onPressed: () {
                        playAll();
                      },
                      child: Container(
                          child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Text(
                            "Play All",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      )),
                    )
                  ],
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Created At",
                          maxLines: 3,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                        Text(
                          DateFormat.yMMMEd().format(
                              widget.slip?.CreatedDate ?? new DateTime(2002)),
                          maxLines: 3,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer?.Name ?? "",
                      maxLines: 3,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    Text(
                      customer?.Address ?? "",
                      maxLines: 3,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              )),
          Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Items Count : ${slipItems.length}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              )),
          isLoading
              ? Expanded(
                  child: Center(
                  child: Wrap(
                      direction: Axis.vertical,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text(
                          "Please Wait..",
                          style: TextStyle(fontSize: 25, color: Colors.grey),
                        )
                      ]),
                ))
              : Expanded(
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
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 15),
                  child: slipItems.length == 0
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
                                  "No Items Found",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.grey),
                                )
                              ]),
                        )
                      : ListView(
                          padding: EdgeInsets.only(
                            bottom: 30,
                          ),
                          children: List.generate(
                            (slipItems.length),
                            (index) => Column(
                              children: [
                                ListTile(
                                  trailing: isEditMode
                                      ? Wrap(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.skip_next_outlined,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  slipItems[index].ID = null;
                                                  slipItems
                                                      .add(slipItems[index]);
                                                  slipItems.removeAt(index);
                                                });
                                              },
                                              padding: EdgeInsets.zero,
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.blueGrey,
                                              ),
                                              onPressed: () {
                                                addOrUpdateSlipItem(
                                                    slipItems[index]);
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
                                                setState(() {
                                                  slipItems.removeAt(index);
                                                  if (slipItems != null &&
                                                      slipItems.length > 0) {
                                                    slipItems.first.ID = null;
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      : Wrap(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                currentPlayIndex != index
                                                    ? Icons
                                                        .play_circle_outline_sharp
                                                    : Icons
                                                        .stop_circle_outlined,
                                                color: currentPlayIndex != index
                                                    ? Colors.blueGrey
                                                    : Colors.red,
                                                size: 40,
                                              ),
                                              onPressed: () async {
                                                if (currentPlayIndex != index) {
                                                  if (currentPlayIndex != -1) {
                                                    await flutterTts.stop();
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 200),
                                                        () {});
                                                  }

                                                  setState(() {
                                                    currentPlayIndex = index;
                                                  });
                                                  flutterTts.speak(
                                                      "Item Number ${slipItems[index].ItemCode.toString().characters.join(" ").replaceAll("0", "zero")} , ${slipItems[index].Item?.Name}  , , , , , , , , , , , , , ,  ,  ,, , , ,  , ,  , , , , ,  ,, , , , , ,, ,  Quantity Is   ${slipItems[index].Qty}");
                                                } else {
                                                  await flutterTts.stop();
                                                  setState(() {
                                                    currentPlayIndex = -1;
                                                  });
                                                }
                                              },
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Item#: ${slipItems[index].ItemCode}",
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        "${slipItems[index].Item?.Name ?? ""}",
                                        maxLines: 3,
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "QTY#: ${slipItems[index].Qty}",
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider()
                              ],
                            ),
                          )),
                )),
        ],
      ),
    );
  }

  scanSlip() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Action'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      setState(() {
                        isLoading = true;
                      });
                      final pickedFile = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _ocr(pickedFile.path);
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    title: Text("Pick From Gallary"),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });

                      Navigator.pop(context);
                      final pickedFile = await ImagePicker()
                          .getImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        _ocr(pickedFile.path);
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    title: Text("Take From Camera"),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _ocr(url) async {
    try {
      var selectList = ["eng"];
      var path = url;
      var _ocrText = await FlutterTesseractOcr.extractText(url,
          language: selectList.join("+"),
          args: {
            "preserve_interword_spaces": "1",
          });
      setState(() {
        isLoading = false;
      });

      if (_ocrText.contains("\n")) {
        print(_ocrText);
        var lines = _ocrText.split("\n");

        var ind = -1;
        if (lines != null && lines.length > 0) {
          for (int l = 0; l < lines.length; l++) {
            if (lines[l].replaceAll(" ", "").startsWith("QTY.") ||
                lines[l].replaceAll(" ", "").contains("ITEM#") ||
                lines[l].replaceAll(" ", "").endsWith("DESCRIPTION")) {
              ind = l;
              break;
            }
          }
        }

        if (ind != -1 && ind + 1 <= lines.length) {
          final alphanumeric = RegExp(r'([0-9]+[ ]+[0-9]+[ ]+(\S*(?: +)*)+)\w');
          for (int m = ind + 1; m < lines.length; m++) {
            lines[m] = lines[m]
                .replaceAll("§", "5")
                .replaceAll("\$", "5")
                .replaceAll("S", "5")
                .replaceAll(":", "1")
                .replaceAll("{", "1")
                .replaceAll(".", " ")
                .replaceAll("io", "10")
                .replaceAll(",", "1")
                .replaceAll("is", "18")
                .replaceAll("g", "8");
            var matches = alphanumeric.allMatches(lines[m]);

            if (matches.length > 0 && matches.first.groupCount > 0) {
              //   print("testing $m : ${matches.first.group(0)}");

              var linebreaks =
                  matches.first.group(0)?.split(' ') as List<String>;
              linebreaks = linebreaks.where((k) => k.isNotEmpty).toList();

              if (linebreaks.length >= 3 &&
                  linebreaks[0].contains(new RegExp(r'[0-9]')) &&
                  linebreaks[1].contains(new RegExp(r'[0-9]'))) {
                var iCode = int.tryParse(linebreaks[1]);
                var ind = slipItems.indexWhere((k) => k.ItemCode == iCode);
                var _items =
                    items.where((element) => element.ItemCode == "${iCode}");
                if (ind == -1) {
                  if (_items != null && _items.length > 0) {
                    setState(() {
                      slipItems.add(SlipItemsModel(
                          ItemCode: iCode,
                          Qty: int.tryParse(linebreaks[0]),
                          Item: _items.first));
                    });
                  } else {
                    setState(() {
                      slipItems.add(SlipItemsModel(
                          ItemCode: iCode,
                          Qty: int.tryParse(linebreaks[0]),
                          Item: ItemModel(Name: "Unknown")));
                    });
                  }
                } else {
                  setState(() {
                    slipItems[ind].ID = null;
                    slipItems[ind].Qty = int.tryParse(linebreaks[0]);
                  });
                }
              }
            } else {
              print("t$m : ${lines[m]}");
            }
          }
          setState(() {
            slipItems = MakeInSequence(slipItems);
          });
          return;
        }
      }
      Fluttertoast.showToast(
          msg: "Scanned slip format is not correct.Kindly scan correctly.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (Ex) {
      Fluttertoast.showToast(
          msg: "Scanned slip format is not correct.Kindly scan correctly.$Ex",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {});
  }

  addOrUpdateSlipItem(SlipItemsModel? _slipitem) async {
    TextEditingController _Ntext =
        TextEditingController(text: _slipitem?.Item?.Name ?? "");

    TextEditingController _ItemCodetext =
        TextEditingController(text: _slipitem?.ItemCode?.toString() ?? "");

    TextEditingController _Qtytext =
        TextEditingController(text: _slipitem?.Qty?.toString() ?? "");

    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('${_slipitem != null ? "Update" : "Add"} Slip Item'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: _ItemCodetext,
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        var ic = val;
                        var _it =
                            items.where((element) => element.ItemCode == ic);
                        if (_it != null && _it.length > 0)
                          _Ntext.text = _it.first.Name ?? "";
                        else
                          _Ntext.text = "Unknown";
                      }
                    },
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
                    controller: _Ntext,
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Item Name',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _Qtytext,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a Qty',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text('Save'),
                onPressed: () async {
                  if (_Ntext.text.isEmpty ||
                      _ItemCodetext.text.isEmpty ||
                      _Qtytext.text.isEmpty ||
                      int.tryParse(_Qtytext.text) == 0) {
                    return;
                  }
                  if (_slipitem == null &&
                      slipItems != null &&
                      slipItems.any((element) =>
                              element.ItemCode.toString() ==
                              _ItemCodetext.text) ==
                          true) {
                    Fluttertoast.showToast(
                        msg: "Item already added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }
                  var itemCode = _ItemCodetext.text;
                  var qty = _Qtytext.text;
                  var _items =
                      items.where((element) => element.ItemCode == itemCode);

                  if (_slipitem != null) {
                    setState(() {
                      _slipitem.ID = null;
                      _slipitem.ItemCode = int.tryParse(itemCode);
                      _slipitem.Qty = int.tryParse(qty);
                      _slipitem.SlipKey = widget.slip?.ID;
                      _slipitem.Item = _items != null && _items.length > 0
                          ? _items.first
                          : new ItemModel(Name: "Unknown");
                    });
                  } else {
                    setState(() {
                      slipItems.add(SlipItemsModel(
                          ItemCode: int.tryParse(itemCode),
                          Qty: int.tryParse(qty),
                          SlipKey: widget.slip?.ID,
                          Item: _items != null && _items.length > 0
                              ? _items.first
                              : null));
                    });
                  }
                  setState(() {
                    slipItems = MakeInSequence(slipItems);
                  });
                  Navigator.pop(context);
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

  playAll() async {
    if (currentPlayIndex != -1) {
      await flutterTts.stop();
    }
    for (int index = 0; index < slipItems.length; index++) {
      setState(() {
        currentPlayIndex = index;
      });
      var text = await listen(index);
      if (text.contains("repeat")) {
        index -= 1;
      }
    }
    ;
  }

  Future<String> listen(index) async {
    if (_speechEnabled) {
      var text = "";
      isEnd = false;
      print("listening...");
      _speechToText.listen(
        onResult: (result) {
          if (text.isEmpty && result.recognizedWords.contains("repeat")) {
            text = result.recognizedWords;
            print("listened : $text");
          } else if (text.isEmpty && result.recognizedWords.contains("next")) {
            text = result.recognizedWords;
            flutterTts.stop();
            print("listened : $text");
          }
        },
      );
      await flutterTts.speak(
          "Item Number ${slipItems[index].ItemCode.toString().characters.join(" ").replaceAll("0", "zero")} , ${slipItems[index].Item?.Name}    Quantity Is   ${slipItems[index].Qty}");

      if (text.isEmpty) {
        await Future.delayed(Duration(seconds: 3), (() async {
          await _speechToText.stop();
        }));
      } else {
        await _speechToText.stop();
      }
      return text;
    } else {
      await Future.delayed(Duration(milliseconds: 500), (() async {
        await _speechToText.stop();
      }));
    }

    return "";
  }

  Future<void> save() async {
    if (slipItems.any((element) => element.ID == null)) {
      setState(() {
        isLoading = true;
      });
      var savedItems =
          await SlipItemsModel().insertAll(slipItems, widget.slip?.ID ?? 0);
      setState(() {
        setState(() {
          slipItems = makeItemAdd(savedItems);
          isLoading = false;
          isEditMode = false;
        });
      });
    }
  }

  List<SlipItemsModel> MakeInSequence(List<SlipItemsModel> o_items) {
    print("Sequencing");
    List<SlipItemsModel> n_items = [];
    if (customer != null && customer?.Extra != null && customer?.Extra != '') {
      List sequence = [];
      try {
        if ((customer?.Extra ?? "").isNotEmpty &&
            json.decode(customer?.Extra ?? "")["Sequence"] != null) {
          print(customer?.Extra ?? "");
          sequence = (json.decode(customer?.Extra ?? "")["Sequence"] as List);
          print(sequence);
          sequence.forEach((se) {
            print(se);
            var ind = o_items.indexWhere((oi) => oi.ItemCode.toString() == se);
            if (ind >= 0) {
              n_items.add(o_items[ind]);
              o_items.removeAt(ind);
            }
          });
        }
      } catch (ex) {}
    }
    n_items.addAll(o_items);
    return n_items;
  }
}
