import 'package:flutter/material.dart';
import 'package:points/qr_code/components/qr_code_scanner.dart';

class QRCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRCodeScanner(),  // QR code scanner as the background layer
          _buildOverlay(),  // Overlay to darken the areas outside the scan box
          Center(
            child: CustomPaint(
              size: Size(250, 250), // Size of the scan box
              painter: QRCodeFramePainter(), // Custom painter to draw the scan box frame
            ),
          ),
        ],
      ),
    );
  }

  // Builds the overlay to darken the areas around the scan box
  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final scanBoxSize = 250.0; // Size of the scan box

        return Stack(
          children: [
            // Top overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: (height - scanBoxSize) / 2,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // Bottom overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: (height - scanBoxSize) / 2,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // Left side overlay
            Positioned(
              top: (height - scanBoxSize) / 2,
              left: 0,
              width: (width - scanBoxSize) / 2,
              height: scanBoxSize,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // Right side overlay
            Positioned(
              top: (height - scanBoxSize) / 2,
              right: 0,
              width: (width - scanBoxSize) / 2,
              height: scanBoxSize,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        );
      },
    );
  }
}

class QRCodeFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFF26101) // Color of the frame
      ..strokeWidth = 6.0 // Thickness of the frame lines
      ..strokeCap = StrokeCap.square // Square end cap for the lines
      ..style = PaintingStyle.stroke; // Style set to stroke

    final double cornerLength = 20.0; // Length of the corner lines

    final leftTop = Offset(0, 0);
    final leftBottom = Offset(0, size.height);
    final rightTop = Offset(size.width, 0);
    final rightBottom = Offset(size.width, size.height);

    // Horizontal and vertical offsets for the corner lines
    final horizontalOffset = Offset(cornerLength, 0);
    final verticalOffset = Offset(0, cornerLength);

    // Draw the corner lines
    // Top-left corner
    canvas.drawLine(leftTop, leftTop + horizontalOffset, paint);
    canvas.drawLine(leftTop, leftTop + verticalOffset, paint);
    // Bottom-left corner
    canvas.drawLine(leftBottom, leftBottom + horizontalOffset, paint);
    canvas.drawLine(leftBottom, leftBottom - verticalOffset, paint);
    // Top-right corner
    canvas.drawLine(rightTop, rightTop - horizontalOffset, paint);
    canvas.drawLine(rightTop, rightTop + verticalOffset, paint);
    // Bottom-right corner
    canvas.drawLine(rightBottom, rightBottom - horizontalOffset, paint);
    canvas.drawLine(rightBottom, rightBottom - verticalOffset, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false; // No need to repaint
}
