import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('QR Code'),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Center(
          child: QrImageView(
            data: 'https://example.com',
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
      ),
    );
  }
}
