import 'dart:developer';
import 'dart:io';

import 'package:delivery_boy/Helper/CommonWidgets.dart';
import 'package:delivery_boy/Helper/Constant.dart';
import 'package:delivery_boy/Helper/RequestManager.dart';
import 'package:delivery_boy/Helper/SharedManaged.dart';
import 'package:delivery_boy/generated/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_boy/BLoC/MainModelBlocClass/StatusOrderBloC.dart';

class QRViewExample extends StatefulWidget {
  final userId;
  const QRViewExample({Key key, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode result;
  QRViewController controller;
  List<String> url;
  String orderId;
  String ticketstatus;
  String type;
  TextEditingController reason = new TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  Future<bool> pickedUpFromTheRestaurant(
      String orderId, String type, String reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final driveriD = prefs.getString(DefaultKeys.userId);

    var param = {
      //  "latitude": "${SharedManager.shared.latitude}",
      //  "longitude": "${SharedManager.shared.longitude}",
      //  "status": "6",
      //   "signature": "",
      "order_id": orderId,
      "driver_id": driveriD,
      "type": type,
      "note": reason,
    };
    print("Accepr Reject Order Id :$orderId" + "driverid: $driveriD");

    //showSnackbar('${S.current.loading}', scaffoldKey);
    final reqManager = Requestmanager();
    bool status = false;
    await reqManager.pickuOrederFromTheRestaurant(param).then((value) {
      status = value;
    });
    return status;
  }

  void _resetFields() {
    reason.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey[200],
        child: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            if (result != null)
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // if (result != null)
                      //   Text(
                      //       'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
                      // else
                      //   const Text('Scan a code'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    AppColor.themeColor,
                                  ),
                                ),
                                onPressed: () async {
                                  await controller?.toggleFlash();
                                  setState(() {});
                                },
                                child: FutureBuilder(
                                  future: controller?.getFlashStatus(),
                                  builder: (context, snapshot) {
                                    return Text(
                                      'Flash',
                                      style: TextStyle(color: Colors.white),
                                    );
                                    //Text('Flash: ${snapshot.data}');
                                  },
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    AppColor.themeColor,
                                  ),
                                ),
                                onPressed: () async {
                                  await controller?.flipCamera();
                                  setState(() {});
                                },
                                child: FutureBuilder(
                                  future: controller?.getCameraInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return Text(
                                        'Camera facing ${describeEnum(snapshot.data)}',
                                        style: TextStyle(color: Colors.yellow),
                                      );
                                    } else {
                                      return const Text('loading');
                                    }
                                  },
                                )),
                          )
                        ],
                      ),
                      (ticketstatus == "1")
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                // Container(
                                //   margin: const EdgeInsets.all(8),
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       await controller?.pauseCamera();
                                //     },
                                //     child: const Text('pause',
                                //         style: TextStyle(fontSize: 20)),
                                //   ),
                                // ),
                                // Container(
                                //   margin: const EdgeInsets.all(8),
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       await controller?.resumeCamera();
                                //     },
                                //     child: const Text('resume',
                                //         style: TextStyle(fontSize: 20)),
                                //   ),
                                // ),
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColor.themeColor,
                                      onPrimary: Colors.black,
                                    ),
                                    onPressed: () async {
                                      //QRCODE kte kodin poshte duhet ta thrasesh pas scanimit
                                      await pickedUpFromTheRestaurant(
                                              orderId, "2", reason.text)
                                          .then((value) {
                                        // scaffoldKey.currentState
                                        // ignore: deprecated_member_use
                                        //  .hideCurrentSnackBar();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        super.widget));
                                        print(value);
                                      });
                                    },
                                    child: const Text('Merr Porosi',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white)),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColor.themeColor,
                                      onPrimary: Colors.black,

                                      // shape: const BeveledRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.all(Radius.circular(5))),
                                    ),
                                    onPressed: () async {
                                      //QRCODE kte kodin poshte duhet ta thrasesh pas scanimit
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return AlertDialog(
                                                scrollable: true,
                                                titlePadding:
                                                    const EdgeInsets.only(
                                                        top: 25),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(18.0),
                                                  ),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(25),
                                                title: Text(
                                                  'Pako Problematike?',
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Form(
                                                    child: Column(
                                                      children: <Widget>[
                                                        TextFormField(
                                                          maxLines: 2,
                                                          controller: reason,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: 'Arsye',
                                                            icon: Icon(Icons
                                                                .subject_outlined),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 50,
                                                                bottom: 7,
                                                                left: 25),
                                                        child: MaterialButton(
                                                          color: AppColor
                                                              .themeColor,
                                                          child: const Text(
                                                            'Anullo',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _resetFields();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 19,
                                                                bottom: 7),
                                                        child: MaterialButton(
                                                          color: AppColor
                                                              .themeColor,
                                                          child: const Text(
                                                            'Merr Porosi',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            //QRCODE kte kodin poshte duhet ta thrasesh pas scanimit
                                                            await pickedUpFromTheRestaurant(
                                                                    orderId,
                                                                    "3",
                                                                    reason.text)
                                                                .then((value) {
                                                              // scaffoldKey.currentState
                                                              // ignore: deprecated_member_use
                                                              //  .hideCurrentSnackBar();
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          super
                                                                              .widget));
                                                              print(value);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                          });
                                    },
                                    child: const Text(
                                      'Porosi Problematike',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : (ticketstatus == "4")
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: AppColor.themeColor,
                                          onPrimary: Colors.black,
                                        ),
                                        onPressed: () async {
                                          //QRCODE kte kodin poshte duhet ta thrasesh pas scanimit
                                          await pickedUpFromTheRestaurant(
                                                  orderId, "5", reason.text)
                                              .then((value) {
                                            // scaffoldKey.currentState
                                            // ignore: deprecated_member_use
                                            //  .hideCurrentSnackBar();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        super.widget));
                                            print(value);
                                          });
                                        },
                                        child: const Text('Dorezo ne Magazine',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: AppColor.themeColor,
                                          onPrimary: Colors.black,
                                        ),
                                        onPressed: () async {
                                          //QRCODE kte kodin poshte duhet ta thrasesh pas scanimit
                                          await pickedUpFromTheRestaurant(
                                                  orderId, "7", reason.text)
                                              .then((value) {
                                            // scaffoldKey.currentState
                                            // ignore: deprecated_member_use
                                            //  .hideCurrentSnackBar();
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        super.widget));
                                            print(value);
                                          });
                                        },
                                        child: const Text('Dorezo tek Klienti',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                )
                              : (ticketstatus == "5")
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.all(8),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: AppColor.themeColor,
                                              onPrimary: Colors.black,
                                            ),
                                            onPressed: () async {
                                              //QRCODE kte kodin poshte duhet ta thrasesh pas scanimit
                                              await pickedUpFromTheRestaurant(
                                                      orderId, "6", reason.text)
                                                  .then((value) {
                                                // scaffoldKey.currentState
                                                // ignore: deprecated_member_use
                                                //  .hideCurrentSnackBar();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            super.widget));
                                                print(value);
                                              });
                                            },
                                            child: const Text(
                                                'Marre nga Magazina',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    )
                                  : (ticketstatus == "6")
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.all(8),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: AppColor.themeColor,
                                                  onPrimary: Colors.black,
                                                ),
                                                onPressed: () async {
                                                  //QRCODE kte kodin poshte duhet ta thrasesh pas scanimit
                                                  await pickedUpFromTheRestaurant(
                                                          orderId,
                                                          "7",
                                                          reason.text)
                                                      .then((value) {
                                                    // scaffoldKey.currentState
                                                    // ignore: deprecated_member_use
                                                    //  .hideCurrentSnackBar();
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                super.widget));
                                                    print(value);
                                                  });
                                                },
                                                child: const Text(
                                                    'Dorezo tek Klienti',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = MediaQuery.of(context).size.width * 0.8;
    //(MediaQuery.of(context).size.width < 400 ||
    //         MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        var fullurl = result.code;
        print("LALALAALLALALATETTE " + fullurl.split("/").last);
        orderId = fullurl.split("/").last;
        url = fullurl.split("/");
        //ticketstatus = url[url.length - 2];
        print(url);
        final reqManager = Requestmanager();

        reqManager.getOrderStatus(orderId).then((value) {
          ticketstatus = value.result.ticketstatus;
        });
        print("Statusi i tiketes eshte: " + ticketstatus);
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
