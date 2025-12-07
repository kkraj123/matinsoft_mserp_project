import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              facing: CameraFacing.back,
              torchEnabled: false,
              returnImage: false,
            ),
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              final String? value = barcode.rawValue;
              if (value != null) {
                Navigator.pop(context, value); // return scanned value
              }
            },
          ),

          // Dark overlay with transparent rectangle
          Center(
            child: Container(
              width: 250, // rectangle width
              height: 250, // rectangle height
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Optional: dim the outside area
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),

          // Cut out the center rectangle
          Center(
            child: Container(
              width: 250,
              height: 250,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
