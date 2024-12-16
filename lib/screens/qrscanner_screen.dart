import 'dart:io';
import 'package:ecoscan/models/user.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ecoscan/backend-client/claim_withdrawal_handler.dart';
import 'package:ecoscan/backend-client/get_local_user.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isScanning = true;
  bool isProcessing = false;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    if (controller != null) return;
    getLocalUser().then((user) {
      if (mounted) {
        setState(() {
          currentUser = user;
        });
      }
    });
  }

  void onQRScanned(String qrData) async {
    // if (isProcessing || currentUser == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(currentUser == null
    //           ? 'User not logged in'
    //           : 'Processing previous scan'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    //   return;
    // }
    try {
      final withdrawalId = int.tryParse(qrData);
      if (withdrawalId == null) {
        throw FormatException('Invalid QR code format');
      }

      final userId = await getId(currentUser!.username);
      if (userId == -1) {
        throw FormatException('Failed to get user ID');
      }

      final result = await claimWithdrawal(withdrawalId, userId);

      if (!mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Points claimed successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        await Future.delayed(Duration(seconds: 2));
        if (mounted && Navigator.canPop(context)) Navigator.pop(context);
        _resetScanner();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'Failed to claim withdrawal'),
            backgroundColor: Colors.red,
          ),
        );
        _resetScanner();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        _resetScanner();
      }
    }
  }

  void _resetScanner() {
    if (mounted) {
      setState(() {
        result = null;
        isScanning = true;
        isProcessing = false;
      });
      Future.delayed(Duration(milliseconds: 200), () {
        controller?.resumeCamera();
      });
    }
  }

  void _handleResult(Barcode scanData) {
    if (!mounted || isProcessing || scanData.code == null) return;

    setState(() {
      result = scanData;
      isProcessing = true;
      isScanning = false;
    });

    controller?.pauseCamera();
    onQRScanned(scanData.code!);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera().then((_) {
        controller?.resumeCamera();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetScanner,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: isProcessing
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentUser != null)
                          Text('Logged in as: ${currentUser!.username}'),
                        Text('Scan a withdrawal QR code'),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (isScanning && scanData.code != null) {
        _handleResult(scanData);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
