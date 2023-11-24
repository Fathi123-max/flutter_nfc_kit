import 'dart:io' show sleep;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class ReadWidget extends StatefulWidget {
  @override
  State<ReadWidget> createState() => _ReadWidgetState();
}

class _ReadWidgetState extends State<ReadWidget> {
  NFCAvailability _availability = NFCAvailability.not_supported;
  String? _result, _mifareResult;
  String _platformVersion = '';
  NFCTag? _tag;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
          const SizedBox(height: 20),
          Text('Running on: $_platformVersion\nNFC: $_availability'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              try {
                NFCTag tag = await FlutterNfcKit.poll();
                setState(() {
                  _tag = tag;
                });
                await FlutterNfcKit.setIosAlertMessage("Working on it...");
                _mifareResult = null;
                if (tag.standard == "ISO 14443-4 (Type B)") {
                  String result1 = await FlutterNfcKit.transceive("00B0950000");
                  String result2 = await FlutterNfcKit.transceive(
                      "00A4040009A00000000386980701");
                  setState(() {
                    _result = '1: $result1\n2: $result2\n';
                  });
                } else if (tag.type == NFCTagType.iso18092) {
                  String result1 =
                      await FlutterNfcKit.transceive("060080080100");
                  setState(() {
                    _result = '1: $result1\n';
                  });
                } else if (tag.ndefAvailable ?? false) {
                  var ndefRecords = await FlutterNfcKit.readNDEFRecords();
                  var ndefString = '';
                  for (int i = 0; i < ndefRecords.length; i++) {
                    ndefString += '${i + 1}: ${ndefRecords[i]}\n';
                  }
                  setState(() {
                    _result = ndefString;
                  });
                } else if (tag.type == NFCTagType.webusb) {
                  var r =
                      await FlutterNfcKit.transceive("00A4040006D27600012401");
                  print(r);
                }
              } catch (e) {
                setState(() {
                  _result = 'error: $e';
                });
              }

              // Pretend that we are working
              if (!kIsWeb) sleep(new Duration(seconds: 1));
              await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
            },
            child: Text('Start polling'),
          ),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _tag != null
                  ? Text(
                      'ID: ${_tag!.id}\nStandard: ${_tag!.standard}\nType: ${_tag!.type}\nATQA: ${_tag!.atqa}\nSAK: ${_tag!.sak}\nHistorical Bytes: ${_tag!.historicalBytes}\nProtocol Info: ${_tag!.protocolInfo}\nApplication Data: ${_tag!.applicationData}\nHigher Layer Response: ${_tag!.hiLayerResponse}\nManufacturer: ${_tag!.manufacturer}\nSystem Code: ${_tag!.systemCode}\nDSF ID: ${_tag!.dsfId}\nNDEF Available: ${_tag!.ndefAvailable}\nNDEF Type: ${_tag!.ndefType}\nNDEF Writable: ${_tag!.ndefWritable}\nNDEF Can Make Read Only: ${_tag!.ndefCanMakeReadOnly}\nNDEF Capacity: ${_tag!.ndefCapacity}\nMifare Info:${_tag!.mifareInfo} Transceive Result:\n$_result\n\nBlock Message:\n$_mifareResult')
                  : const Text('No tag polled yet.')),
        ]))));
  }
}
