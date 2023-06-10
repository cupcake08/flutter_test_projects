import 'package:flutter/material.dart';
import 'package:pet_adoption_app/providers/providers.dart';
import 'package:pet_adoption_app/screens/screens.dart';
import 'package:pet_adoption_app/utils/extensions.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: 300.ms,
    );
    context.read<PetsNotifier>().setCurrentCategorySelectedIndex(0, notify: false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Image.asset(
            "assets/7953025-min.jpg",
            fit: BoxFit.fitHeight,
            height: context.height * .8,
          ),
          CustomPaint(
            painter: CirclePainter(_animationController),
            size: Size(context.width, context.height * .75),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: 1 - _animationController.value,
                  child: child!,
                );
              },
              child: _introText(),
            ),
          ),
        ],
      ),
    );
  }

  _introText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Proud to Be A\nPet Adopter",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          "Looking for unconsitional love?\nVisit the shelter today!",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (_animationController.isCompleted) {
              _animationController.reset();
            }
            _animationController.forward();
            await Future.delayed(300.ms);
            if (!mounted) return;
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionsBuilder: (_, animation, __, child) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 1,
            backgroundColor: const Color(0xFFFCAB4C),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.all(0),
            fixedSize: Size(context.width * .5, context.height * .06),
          ),
          child: Row(
            children: [
              SizedBox(width: context.width * .05),
              const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(context.width * .02),
                child: Icon(
                  Icons.pets,
                  size: context.height * .03,
                  color: const Color(0xFFFCAB4C),
                ),
              ),
              SizedBox(width: context.width * .015),
            ],
          ),
        ),
        SizedBox(height: context.height * .03)
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final Paint _paint;
  final AnimationController controller;
  CirclePainter(this.controller)
      : _paint = Paint()..color = Colors.white,
        super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final center = Offset(size.width / 2, size.height + size.height * .8);
    if (controller.value < .5) {
      canvas.drawCircle(
        center,
        size.height,
        _paint,
      );
    } else {
      canvas.drawCircle(
        center,
        size.height * (2 * controller.value),
        _paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
