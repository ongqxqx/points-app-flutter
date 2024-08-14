import 'package:flutter/material.dart';
import 'package:points/qr_code/components/qr_code_scanner.dart';

class QRCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRCodeScanner(),  // 扫描器作为底层背景
          _buildOverlay(),
          Center(
            child: CustomPaint(
              size: Size(250, 250),
              painter: QRCodeFramePainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final scanBoxSize = 250.0;

        return Stack(
          children: [
            // 顶部遮罩
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: (height - scanBoxSize) / 2,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // 底部遮罩
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: (height - scanBoxSize) / 2,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // 左侧遮罩
            Positioned(
              top: (height - scanBoxSize) / 2,
              left: 0,
              width: (width - scanBoxSize) / 2,
              height: scanBoxSize,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // 右侧遮罩
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
      ..color = Color(0xFFF26101)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    final double cornerLength = 20.0;

    final leftTop = Offset(0, 0);
    final leftBottom = Offset(0, size.height);
    final rightTop = Offset(size.width, 0);
    final rightBottom = Offset(size.width, size.height);

    // 横向线条的坐标偏移
    final horizontalOffset = Offset(cornerLength, 0);
    // 纵向线条的坐标偏移
    final verticalOffset = Offset(0, cornerLength);

    // 左上角
    canvas.drawLine(leftTop, leftTop + horizontalOffset, paint);
    canvas.drawLine(leftTop, leftTop + verticalOffset, paint);
    // 左下角
    canvas.drawLine(leftBottom, leftBottom + horizontalOffset, paint);
    canvas.drawLine(leftBottom, leftBottom - verticalOffset, paint);
    // 右上角
    canvas.drawLine(rightTop, rightTop - horizontalOffset, paint);
    canvas.drawLine(rightTop, rightTop + verticalOffset, paint);
    // 右下角
    canvas.drawLine(rightBottom, rightBottom - horizontalOffset, paint);
    canvas.drawLine(rightBottom, rightBottom - verticalOffset, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
