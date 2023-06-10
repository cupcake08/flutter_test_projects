import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_adoption_app/animations/heart_animation.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/providers/providers.dart';
import 'package:pet_adoption_app/screens/screens.dart';
import 'package:pet_adoption_app/utils/utils.dart';
import 'package:provider/provider.dart';

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen({super.key, required this.pet});
  final Pet pet;

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final bool isDarkMode;

  late final ValueNotifier<bool> _isAdopted;

  @override
  void initState() {
    super.initState();
    _isAdopted = ValueNotifier(widget.pet.isAdopted);
    isDarkMode = context.read<ThemeProvider>().themeMode == ThemeMode.dark;
    _animationController = AnimationController(
      vsync: this,
      duration: 800.ms,
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: 400.ms,
                        pageBuilder: (_, __, ___) => ImageViewScreen(
                          imageUrl: widget.pet.image,
                          id: widget.pet.id,
                        ),
                        transitionsBuilder: (_, animation, __, child) => FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: "pet${widget.pet.id}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.pet.image,
                        fit: BoxFit.cover,
                        height: context.height * .45,
                        width: context.width,
                      ),
                    ),
                  ),
                ),
                SlideTransition(
                  position: Tween(begin: const Offset(0, -0.8), end: Offset.zero).animate(curvedAnimation),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: _petDetail(),
                  ),
                ),
                SlideTransition(
                  position: Tween(begin: const Offset(0, -1), end: Offset.zero).animate(curvedAnimation),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: _descriptionWidget(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SlideTransition(
            position: Tween(begin: const Offset(0, 2), end: Offset.zero).animate(curvedAnimation),
            child: Row(
              children: [
                Expanded(child: _adoptionButton()),
                HeartAnimation(pet: widget.pet),
                SizedBox(width: context.width * .05),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  _adoptionButton() {
    final spacer = SizedBox(width: context.height * .008);
    return ValueListenableBuilder(
        valueListenable: _isAdopted,
        builder: (context, isAdopted, _) {
          return InkWell(
            onTap: isAdopted ? null : _adoptPetAction,
            child: Container(
              height: context.height * .06,
              margin: EdgeInsets.symmetric(horizontal: context.width * .05),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.height * .04),
                color: isAdopted ? Colors.grey : AppColor.orange,
              ),
              child: Row(
                children: [
                  SizedBox(width: context.width * .05),
                  Text(
                    isAdopted ? "Already Adopted!" : "Adopt Pet",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(context.height * .01),
                    child: const Icon(
                      Icons.pets,
                      color: AppColor.orange,
                    ),
                  ),
                  spacer,
                ],
              ),
            ),
          );
        });
  }

  _descriptionWidget() {
    final spacer = SizedBox(height: context.height * .02);
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: context.height * .03,
              backgroundImage: const AssetImage("assets/bird-min.jpg"),
            ),
            SizedBox(width: context.width * .02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.pet.ownerName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Owner",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: isDarkMode ? Colors.grey.shade300 : Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "8 Feb. 2023",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: isDarkMode ? Colors.grey.shade300 : Colors.grey),
            ),
          ],
        ),
        spacer,
        _petDetailByOwner(),
        spacer,
        _desciption(),
      ],
    );
  }

  _petDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.pet.name,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
              ),
              Text(
                widget.pet.breed,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: isDarkMode ? Colors.grey.shade300 : Colors.grey,
                    ),
              ),
            ],
          ),
          const Spacer(),
          Icon(
            _getIconBasedOnGender(),
            size: context.height * .045,
            color: AppColor.orange,
          ),
        ],
      ),
    );
  }

  _adoptPetAction() {
    _isAdopted.value = true;
    context.read<PetsNotifier>().markPetAsAdopted(widget.pet);
    return showGeneralDialog(
      context: context,
      transitionBuilder: (_, animation, __, child) => ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieBuilder.asset(
                "assets/adopt_pet_lottie.json",
                repeat: false,
                height: context.height * .3,
              ),
              Text(
                "Thank you for adopting\n${widget.pet.name}!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              // back to home Elevated button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: Text(
                  "Back to Home",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  IconData _getIconBasedOnGender() {
    switch (widget.pet.gender) {
      case Gender.male:
        return Icons.male;
      case Gender.female:
        return Icons.female;
    }
  }

  _petDetailByOwner() {
    final containerHeight = context.height * .08;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.amber : Colors.amber.shade200,
        borderRadius: BorderRadius.circular(context.height * .02),
      ),
      height: containerHeight,
      width: context.width * .75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          _petDetailSub("Age", _calculateAgeBasedOnDOB()),
          CustomPaint(
            painter: _CustomVerticalDivider(),
            size: Size(1, containerHeight * .6),
          ),
          _petDetailSub("Weight", "4.5 Kg"),
        ],
      ),
    );
  }

  _calculateAgeBasedOnDOB() {
    final dob = widget.pet.birthDate;
    final now = DateTime.now();
    final age = now.difference(dob).inDays ~/ 365;
    return "$age Years";
  }

  _petDetailSub(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: isDarkMode ? Colors.grey.shade100 : Colors.grey),
        ),
      ],
    );
  }

  _desciption() {
    const x =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, justo ac ultrices ultricies, nisl nunc ultrices dolor, quis aliquam nisl nunc ut nisl. Sed euismod, justo ac ultrices ultricies, nisl nunc ultrices dolor, quis aliquam nisl nunc ut nisl.";

    final style = Theme.of(context).textTheme.titleSmall!.copyWith(color: isDarkMode ? Colors.grey.shade200 : Colors.grey);
    if (x.length > 130) {
      return Text.rich(
        TextSpan(
          text: x.substring(0, 130),
          style: style,
          children: [
            TextSpan(
              text: "...Read More",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : null,
                  ),
            ),
          ],
        ),
      );
    }
    return Text(
      x,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
    );
  }
}

class _CustomVerticalDivider extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
