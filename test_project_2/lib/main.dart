import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

void main() {
  runApp(const MyApp());
}

extension Log on Object {
  void log() => dev.log(toString());
}

extension ConstraintsEx on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get width => size.width;
  double get height => size.height;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background
          CustomPaint(
            painter: BackgroundPainter(),
            size: Size(context.width, context.height),
            foregroundPainter: BubblePainter(
              circleCenters: [
                Offset(context.width * .45, context.height * .45),
                Offset(context.width * .35, context.height * .55),
                Offset(context.width, context.height * .8),
              ],
              radius: context.width * .27,
            ),
          ),
          // middle logo
          Align(
            alignment: Alignment.center,
            child: Text(
              "G Pay",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 80,
                  ),
            ),
          ),
          // bottom button
          Positioned(
            bottom: 30,
            left: (context.width - context.width * .9) / 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                fixedSize: Size(context.width * .9, context.height * .07),
              ),
              child: Text(
                "Get Started",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.w500, color: Colors.black54),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final double radius;
  final List<Offset> circleCenters;

  BubblePainter({required this.circleCenters, this.radius = 90.0});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(.1);
    for (Offset position in circleCenters) {
      canvas.drawCircle(position, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.pink,
          Colors.blue,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);

    canvas.drawPaint(paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
