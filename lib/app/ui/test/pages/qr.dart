import 'package:flutter/material.dart';
import 'package:ruhrkultur/app/ui/test/pages/music.dart';
import 'package:qrcode_barcode_scanner/qrcode_barcode_scanner.dart';

class QRViewPage extends StatefulWidget {
  @override
  _QRViewPageState createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  String? result;
  String? _scanValue;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: TextButton(
              onPressed: () {
                QrcodeBarcodeScanner(
                  onScannedCallback: (String value) => setState(
                    () {
                      _scanValue = value;
                    },
                  ),
                );
              },
              child: Text('Start QR Code Scanner'),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (_scanValue != null)
                  ? Text('Data: $_scanValue')
                  : Text('Scan a code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRCodeScanned(String code) {
    setState(() {
      result = code;
      _handleQRCode(code);
    });
  }

  void _handleQRCode(String code) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerPage(musicId: code),
      ),
    );
  }
}
