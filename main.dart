import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart' as mlkit;

void main() => runApp(QRApp());

class QRApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner & Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: QRHomePage(),
    );
  }
}

class QRHomePage extends StatefulWidget {
  @override
  _QRHomePageState createState() => _QRHomePageState();
}

class _QRHomePageState extends State<QRHomePage> {
  int _selectedIndex = 0;
  final _pages = [QRGeneratePage(), QRScanPage()];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code App"),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Generate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
        ],
      ),
    );
  }
}

// QR GENERATE PAGE
class QRGeneratePage extends StatefulWidget {
  @override
  _QRGeneratePageState createState() => _QRGeneratePageState();
}

class _QRGeneratePageState extends State<QRGeneratePage> {
  String qrData = '';
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: 'Enter text to generate QR',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                setState(() => qrData = textController.text);
              }
            },
            child: Text('Generate QR Code'),
          ),
          const SizedBox(height: 24),
          if (qrData.isNotEmpty)
            Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.0,
                backgroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

// QR SCAN PAGE (LIVE + GALLERY)
class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  qr.Barcode? result;
  qr.QRViewController? controller;
  String galleryScanResult = '';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  Future<void> _pickImageAndScan() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final inputImage = mlkit.InputImage.fromFilePath(pickedFile.path);
      final barcodeScanner = mlkit.BarcodeScanner();

      try {
        final barcodes = await barcodeScanner.processImage(inputImage);
        if (barcodes.isNotEmpty) {
          setState(() {
            galleryScanResult = barcodes.first.rawValue ?? 'No data found';
          });
        } else {
          setState(() {
            galleryScanResult = 'No QR code found in image.';
          });
        }
      } catch (e) {
        setState(() {
          galleryScanResult = 'Error: $e';
        });
      } finally {
        barcodeScanner.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: qr.QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: qr.QrScannerOverlayShape(
              borderColor: Colors.deepPurple,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                result != null
                    ? 'Live Scan: ${result!.code}'
                    : 'Scan a code using the camera',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _pickImageAndScan,
                icon: Icon(Icons.photo),
                label: Text('Choose Image from Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
              if (galleryScanResult.isNotEmpty) ...[
                SizedBox(height: 10),
                Text(
                  'Gallery Scan Result:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    galleryScanResult,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(qr.QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() => result = scanData);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
