import 'package:flutter/material.dart';
import 'package:health_monitoring_app/auth/auth_service.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class BarcodeGenerate extends StatefulWidget {
  const BarcodeGenerate({Key? key}) : super(key: key);
  static const String routeNames = '/BarcodeGenerate';

  @override
  State<BarcodeGenerate> createState() => _BarcodeGenerateState();
}

class _BarcodeGenerateState extends State<BarcodeGenerate> {
  @override
  Widget build(BuildContext context) {
    final uid = AuthService.currentUser?.uid;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pink.shade200, Colors.purple.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: SizedBox(
              height: 300,
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfBarcodeGenerator(
                  value: uid,
                  symbology: QRCode(),
                  // showValue: true,
                  textSpacing: 10,
                  backgroundColor: Colors.white,
                ),
              ),
            )),
            const Text(
              "SCAN ME",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
