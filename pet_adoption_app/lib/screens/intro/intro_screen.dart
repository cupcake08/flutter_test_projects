import 'package:flutter/material.dart';
import 'package:pet_adoption_app/screens/home/home.dart';
import 'package:pet_adoption_app/utils/extensions.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Image.asset(
            "assets/7953025.jpg",
            fit: BoxFit.fitHeight,
            height: context.height * .8,
          ),
          CustomPaint(
            painter: CirclePainter(),
            size: Size(context.width, context.height * .75),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (context, _, __) => const HomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: const Color(0xFFFCAB4C),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(0),
                        fixedSize: Size(context.width * .45, context.height * .06),
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
                            padding: const EdgeInsets.all(5),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height + size.height * .8);
    canvas.drawCircle(
      center,
      size.height,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
