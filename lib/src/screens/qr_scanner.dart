import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qbox_authorization/src/utils/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRScanner> {
  final ValueNotifier<Barcode?> resultNotifier = ValueNotifier(null);
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: _buildQrView(context),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сканируйте QR-код',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Color(0xFF004EEB),
        overlayColor: const Color(0xCE000000),
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;

    controller.scannedDataStream.listen(
      (scanData) async {
        if (!isScanning || scanData.code == null) return;

        try {
          isScanning = false;
          resultNotifier.value = scanData;
          info(
            "QR kod info: ${resultNotifier.value?.code} : scan ${scanData.code}",
          );

          if (mounted) {
            HapticFeedback.mediumImpact();
            Navigator.of(context).pop(scanData.code);
          }
        } catch (e) {
          info('Error during QR scanning: $e');
        }
      },
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
  }

  @override
  void dispose() {
    controller?.dispose();
    resultNotifier.dispose();
    super.dispose();
  }
}
