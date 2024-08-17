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
  bool _scanned = false; // Flag to prevent multiple scans

  // Method to handle QR code scanning
  void _handleQRCode(String qrCode) async {
    if (_scanned) return; // Prevent multiple scans

    setState(() {
      _scanned = true; // Set the flag to true to prevent re-scanning
    });

    cameraController.stop(); // Stop the camera scanning

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      _showLoginDialog(); // Prompt the user to log in
      return;
    }

    try {
      // Fetch QR code document from Firestore
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
          cameraController.start(); // Restart scanning
        });
        return;
      }

      final data = qrCodeDoc.data() as Map<String, dynamic>;
      final active = data['active'];
      final point = data['point'];

      if (active != null && active.isNotEmpty) {
        _showScannedDialog(); // Show dialog if QR code is already used
        return;
      }

      // Update QR code document with the user's ID
      await FirebaseFirestore.instance
          .collection('qr_code_list')
          .doc(qrCode)
          .update({'active': user.uid});

      // Fetch and update the user's points
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

      // Show success dialog with points received
      _showSuccessDialog(point);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing QR Code')),
      );
      setState(() {
        _scanned = false;
        cameraController.start(); // Restart scanning in case of error
      });
    }
  }

  // Show dialog to prompt user to log in
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
                // Navigate to login page or perform login operation
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _scanned = false;
        cameraController.start(); // Restart scanning after dialog is dismissed
      });
    });
  }

  // Show dialog indicating successful points redemption
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
                    0xFFF26101), // Set the button color
              ),
              onPressed: () {
                Get.offAll(() => MainPage()); // Navigate to the main page
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

  // Show dialog if the QR code has already been used
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
                // Optionally navigate to another page
              },
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _scanned = false;
        cameraController.start(); // Restart scanning after dialog is dismissed
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uncomment if you want an AppBar
      // appBar: AppBar(
      //   title: Text('QR Code Scanner'),
      // ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String code = barcode.rawValue ?? '---';
            _handleQRCode(code); // Handle the QR code
            break; // Process only the first detected QR code
          }
        },
      ),
    );
  }
}
