import 'dart:async';
import 'dart:io';
import 'package:flutter_barcode_scanner_example/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main(){
    HttpOverrides.global = MyHttpOverrides();
    runApp( MyApp());
}



class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';
  dynamic barcode;

  @override
  void initState() {
    super.initState();
  }
  

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Brave Barcode Scanner'),
            backgroundColor: Colors.blueAccent,
            ),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start QR scan')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text('Start barcode scan stream')),
                              if (_scanBarcode != 'Unknown'  || (_scanBarcode == '-1' ))
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.green
                              )
                              ),
                                if (_scanBarcode != 'Unknown')
                        ElevatedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(barcode:_scanBarcode))),
                            child: Text('Get Item Details')),
                            
                          if (_scanBarcode == 'Unknown' || (_scanBarcode == '-1' ))
                             Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red
                              )
                              ),
                      ]));
            })));
  }
}

