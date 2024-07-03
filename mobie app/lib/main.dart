import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity/connectivity.dart';
import 'package:register_apk/responce/responce.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRScannerScreen(),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late QRViewController controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TextEditingController manualCodeController = TextEditingController();
  bool isProcessing = false;
  bool isLoading = false;
  bool isQRScanned = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Camera Permission Required'),
          content: const Text('Please grant camera permission to use this feature.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text('Please connect to the internet to use this feature.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('QR Scanner')),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Align QR Code within the frame to scan',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (!isProcessing) showDialogBox();
                    },
                    child: const Text('Enter QR Code Manually'),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isProcessing && !isQRScanned && scanData.code!.isNotEmpty) {
        setState(() {
          isQRScanned = true;
          isProcessing = true;
        });
        Vibration.vibrate(duration: 100); // Vibrate when QR code is scanned
        sendScannedData(scanData.code);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter QR Code Manually'),
          content: TextField(
            controller: manualCodeController,
              keyboardType: TextInputType.number, // Set keyboard type to numerical

            decoration: const InputDecoration(hintText: 'Enter QR Code'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String manualCode = manualCodeController.text;
                if (!isProcessing) {
                  setState(() {
                    isProcessing = true;
                  });
                  sendScannedData(manualCode);
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void sendScannedData(String? scannedData) async {
    if (scannedData != null) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await http.get(Uri.https(
          '6udmxpz3sdcrnt6zcd5vfb644e0zqezb.lambda-url.ap-south-1.on.aws',
          '/path/to/endpoint',
          {
            'type': 'id',
            'id': '$scannedData',
          },
        ));
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResponseScreen(responseData: jsonData,)),
          ).then((_) {
            // Resume scanning after popping from response screen
            setState(() {
              isQRScanned = false;
            });
            controller.resumeCamera();
          });
        } else {
          print(response.body);
          throw Exception('Failed to send data');
        }
      } catch (error) {
        print('Error sending data: $error');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to send data: $error'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } finally {
        setState(() {
          isLoading = false;
          isProcessing = false;
        });
      }
    }
  }
}
