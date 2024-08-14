import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:points/navigation/bottom_navigation_screen.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool _scanned = false;

  void _handleQRCode(String qrCode) async {
    if (_scanned) return;

    setState(() {
      _scanned = true;
    });

    cameraController.stop(); // 确保扫描停止

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      _showLoginDialog();
      return;
    }

    try {
      final qrCodeDoc = await FirebaseFirestore.instance
          .collection('qr_code_list')
          .doc(qrCode)
          .get();

      if (!qrCodeDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code not found')),
        );
        setState(() {
          _scanned = false;
          cameraController.start(); // 重新启动扫描
        });
        return;
      }

      final data = qrCodeDoc.data() as Map<String, dynamic>;
      final active = data['active'];
      final point = data['point'];

      if (active != null && active.isNotEmpty) {
        _showScannedDialog();
        return;
      }

      await FirebaseFirestore.instance
          .collection('qr_code_list')
          .doc(qrCode)
          .update({'active': user.uid});

      final userDoc = await FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .get();

      final userData = userDoc.data() as Map<String, dynamic>;
      final currentPoints = userData['point'] ?? 0;
      final newPoints = currentPoints + point;

      await FirebaseFirestore.instance
          .collection('user_list')
          .doc(user.uid)
          .update({'point': newPoints});

      // 显示成功领取点数的对话框
      _showSuccessDialog(point);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing QR Code')),
      );
      setState(() {
        _scanned = false;
        cameraController.start(); // 重新启动扫描
      });
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Required'),
          content: Text('You need to be logged in to use this feature.'),
          actions: <Widget>[
            TextButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.of(context).pop();
                // 导航到登录页面或执行登录操作
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _scanned = false;
        cameraController.start(); // 重新启动扫描
      });
    });
  }

  void _showSuccessDialog(int points) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('You have received $points points.'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                    0xFFF26101), // Change this to your desired button color
              ),
              onPressed: () {
                Get.offAll(() => MainPage());
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _scanned = false;
      });
    });
  }

  void _showScannedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Code invalid'),
          content: Text('This QR Code has already been used.'),
          actions: <Widget>[
            TextButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
                // 可以在此处导航到其他页面
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _scanned = false;
        cameraController.start(); // 重新启动扫描
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('QR Code Scanner'),
      // ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String code = barcode.rawValue ?? '---';
            _handleQRCode(code);
            break; // 只处理第一个检测到的二维码
          }
        },
      ),
    );
  }
}
