import 'dart:async';
import 'dart:io' show Platform, sleep;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_nfc_kit_example/widgets/read_widget.dart';
import 'package:logging/logging.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:ndef/utilities.dart';

import 'ndef_record/raw_record_setting.dart';
import 'ndef_record/text_record_setting.dart';
import 'ndef_record/uri_record_setting.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(MaterialApp(theme: ThemeData(useMaterial3: true), home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  String _platformVersion = '';
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _result, _writeResult, _mifareResult;
  late TabController _tabController;
  List<ndef.NDEFRecord>? _records;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb)
      _platformVersion =
          '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
    else
      _platformVersion = 'Web';
    initPlatformState();
    _tabController = new TabController(length: 2, vsync: this);
    _records = [];
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
      _availability = availability;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text('NFC Test App'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: 'Read'),
                Tab(text: 'Write'),
              ],
              controller: _tabController,
            )),
        body: new TabBarView(controller: _tabController, children: <Widget>[
          ReadWidget(),
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          if (_records!.length != 0) {
                            try {
                              NFCTag tag = await FlutterNfcKit.poll();
                              setState(() {
                                _tag = tag;
                              });
                              if (tag.type == NFCTagType.mifare_ultralight ||
                                  tag.type == NFCTagType.mifare_classic ||
                                  tag.type == NFCTagType.iso15693) {
                                await FlutterNfcKit.writeNDEFRecords(_records!);
                                setState(() {
                                  _writeResult = 'OK';
                                });
                              } else {
                                setState(() {
                                  _writeResult =
                                      'error: NDEF not supported: ${tag.type}';
                                });
                              }
                            } catch (e, stacktrace) {
                              setState(() {
                                _writeResult = 'error: $e';
                              });
                              print(stacktrace);
                            } finally {
                              await FlutterNfcKit.finish();
                            }
                          } else {
                            setState(() {
                              _writeResult = 'error: No record';
                            });
                          }
                        },
                        child: Text("Start writing"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                    title: Text("Record Type"),
                                    children: <Widget>[
                                      SimpleDialogOption(
                                        child: Text("Text Record"),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          final result = await Navigator.push(
                                              context, MaterialPageRoute(
                                                  builder: (context) {
                                            return NDEFTextRecordSetting();
                                          }));
                                          if (result != null) {
                                            if (result is ndef.TextRecord) {
                                              setState(() {
                                                _records!.add(result);
                                              });
                                            }
                                          }
                                        },
                                      ),
                                      SimpleDialogOption(
                                        child: Text("Uri Record"),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          final result = await Navigator.push(
                                              context, MaterialPageRoute(
                                                  builder: (context) {
                                            return NDEFUriRecordSetting();
                                          }));
                                          if (result != null) {
                                            if (result is ndef.UriRecord) {
                                              setState(() {
                                                _records!.add(result);
                                              });
                                            }
                                          }
                                        },
                                      ),
                                      SimpleDialogOption(
                                        child: Text("Raw Record"),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          final result = await Navigator.push(
                                              context, MaterialPageRoute(
                                                  builder: (context) {
                                            return NDEFRecordSetting();
                                          }));
                                          if (result != null) {
                                            if (result is ndef.NDEFRecord) {
                                              setState(() {
                                                _records!.add(result);
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ]);
                              });
                        },
                        child: Text("Add record"),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Result: $_writeResult'),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child: ListView(
                        shrinkWrap: true,
                        children: List<Widget>.generate(
                            _records!.length,
                            (index) => GestureDetector(
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                          'id:${_records![index].idString}\ntnf:${_records![index].tnf}\ntype:${_records![index].type?.toHexString()}\npayload:${_records![index].payload?.toHexString()}\n')),
                                  onTap: () async {
                                    final result = await Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return NDEFRecordSetting(
                                          record: _records![index]);
                                    }));
                                    if (result != null) {
                                      if (result is ndef.NDEFRecord) {
                                        setState(() {
                                          _records![index] = result;
                                        });
                                      } else if (result is String &&
                                          result == "Delete") {
                                        _records!.removeAt(index);
                                      }
                                    }
                                  },
                                ))),
                  ),
                ]),
          )
        ]),
      ),
    );
  }
}
