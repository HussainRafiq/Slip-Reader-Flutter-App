import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:slip_readerv2/Database/Model/ItemModel.dart';
import 'package:slip_readerv2/Database/Model/SlipItemsModel.dart';
import 'package:slip_readerv2/Database/Model/SlipModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MultiSlipPage extends StatefulWidget {
  final List<SlipModel?>? slips;

  const MultiSlipPage({Key? key, required this.slips}) : super(key: key);
  @override
  _MultiSlipPageState createState() => new _MultiSlipPageState();
}

class _MultiSlipPageState extends State<MultiSlipPage> {
  List<SlipItemsModel> slipItems = [];
  List<ItemModel> items = [];
  FlutterTts flutterTts = FlutterTts();
  bool _speechEnabled = false;
  int currentPlayIndex = -1;
  bool isEnd = false;
  bool isLoading = true;
  bool isPlaying = false, issaying = false;
  SpeechToText _speechToText = SpeechToText();
  Timer? timer;
  Map<int, List<int>> qtys = {};
  @override
  initState() {
    super.initState();

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
        if (!isPlaying) {
          currentPlayIndex = -1;
          isEnd = true;
        }
      });
    });

    items = await ItemModel().get();
    widget.slips?.forEach((slip) {
      setState(() {
        isLoading = true;
      });
      SlipItemsModel().get(slip?.ID ?? 0).then((value) {
        if (value != null && value.length > 0) {
          setState(() {
            makeItemAdd(value).forEach((element) {
              if (qtys.containsKey(element.ItemCode)) {
                qtys[element.ItemCode ?? 0]?.add(element.Qty ?? 0);
              } else {
                slipItems.add(element);
                qtys.putIfAbsent(
                    element.ItemCode ?? 0, () => [element.Qty ?? 0]);
              }
            });

            isLoading = false;
          });
        }
      });
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
    return nlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Slip List"),
        elevation: 0,
      ),
      floatingActionButton: isLoading
          ? Container()
          : Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                isPlaying
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black, onPrimary: Colors.grey),
                        onPressed: null,
                        child: Container(
                            child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              _speechToText.isAvailable
                                  ? "Listening....."
                                  : "stop Litening",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        )),
                      )
                    : Container(),
                SizedBox(
                  width: 10,
                ),
                isPlaying
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red, onPrimary: Colors.grey),
                        onPressed: () {
                          stop();
                        },
                        child: Container(
                            child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Stop Playing",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        )),
                      )
                    : ElevatedButton(
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        )),
                      )
              ],
            ),
      body: Column(
        children: [
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
                                  trailing: Wrap(
                                    children: [
                                      !isPlaying
                                          ? IconButton(
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
                                                  var st =
                                                      "Item Number ${slipItems[index].ItemCode.toString().characters.join(" ").replaceAll("0", "zero")} , ${slipItems[index].Item?.Name}";
                                                  var t = 0;
                                                  qtys[slipItems[index]
                                                          .ItemCode]
                                                      ?.forEach((j) {
                                                    st +=
                                                        "\n Quantity Is   ${j} ";
                                                    t += j;
                                                  });

                                                  flutterTts.speak(st);
                                                } else {
                                                  await flutterTts.stop();
                                                  setState(() {
                                                    currentPlayIndex = -1;
                                                  });
                                                }
                                              },
                                              padding: EdgeInsets.zero,
                                            )
                                          : SizedBox(),
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
                                            color: currentPlayIndex != index
                                                ? Colors.blueGrey
                                                : Colors.amber,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        "${slipItems[index].Item?.Name ?? ""}",
                                        maxLines: 3,
                                        style: TextStyle(
                                            color: currentPlayIndex != index
                                                ? Colors.blueGrey
                                                : Colors.amber,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        "QTY#: ${qtys[slipItems[index].ItemCode]?.join(" , ")}",
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: currentPlayIndex != index
                                                ? Colors.blueGrey
                                                : Colors.amber,
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

  playAll() async {
    if (currentPlayIndex != -1) {
      await flutterTts.stop();
    }
    if (_speechEnabled) {
      setState(() {
        isPlaying = true;
        currentPlayIndex = -1;
      });
      autostartlisten();
    } else {
      Fluttertoast.showToast(msg: "Some Error in Listening");
    }
  }

  stop() {
    setState(() {
      isPlaying = false;
      _speechToText.stop();
    });
  }

  onlisten(result) {
    print(result.recognizedWords);
    if (!issaying) {
      var text = '';
      if (result.recognizedWords.contains("repeat")) {
        text = 'repeat';
      } else if (result.recognizedWords.contains("next")) {
        text = 'next';
        setState(() {
          currentPlayIndex++;
        });
      } else if (result.recognizedWords.contains("previous") &&
          currentPlayIndex > 0) {
        text = 'previous';
        setState(() {
          currentPlayIndex--;
        });
      }
      if (text.isNotEmpty && currentPlayIndex < slipItems.length) {
        flutterTts.stop();
        var st =
            "Item Number ${slipItems[currentPlayIndex].ItemCode.toString().characters.join(" ").replaceAll("0", "zero")} , ${slipItems[currentPlayIndex].Item?.Name}";
        qtys[slipItems[currentPlayIndex].ItemCode]?.forEach((j) {
          st += "\n Quantity Is   ${j} ";
        });
        _speechToText.stop();
        setState(() {
          issaying = true;
        });
        flutterTts.speak(st).then((value) {
          setState(() {
            issaying = false;
          });
          autostartlisten();
        });
      }
    }
  }

  autostartlisten() async {
    print("start");
    if (timer != null) {
      timer?.cancel();
      timer = null;
      setState(() {});
    }

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (issaying == false) {
        print("check");
        _speechToText.listen(onResult: (result) => onlisten(result));
      }
    });
  }
}
