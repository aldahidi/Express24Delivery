import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';



class QrScan extends StatefulWidget {
  const QrScan({ Key key }) : super(key: key);

  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
final qrKey = GlobalKey(debugLabel: 'QR');

QRViewController controller;


@override
void reassemble() async {
  super.reassemble();

  if(Platform.isAndroid) {
    await controller.pauseCamera();
  }
  controller.resumeCamera();
}


@override
void dispose(){
  controller.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) => SafeArea(child: Scaffold(
  body: Stack(
    alignment: Alignment.center,
    children: <Widget>[
      buildQrView(context),
      Positioned(bottom: 10, child: buildResult())
    ],
  ),
  ));

Widget buildResult() => Text(
"Scan a codeee",
maxLines: 3,
);

  Widget buildQrView (BuildContext context) => QRView(key: qrKey, onQRViewCreated: onQRViewCreated,
  overlay: QrScannerOverlayShape(
    borderWidth: 10,
    borderLength: 20,
    borderRadius: 10,
    cutOutSize: MediaQuery.of(context).size.width * 0.8),
    );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
   controller.scannedDataStream.listen((barcode) => setState(() => {
    // this.barcode = barcode
   }));
  }
}