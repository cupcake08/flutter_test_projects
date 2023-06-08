import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/utils/utils.dart';

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen({super.key, required this.index, required this.pet});
  final int index;
  final Pet pet;

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: 800.ms,
    );
    _animationController.forward();
    AppInit.prefs.clear();
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
                Hero(
                  tag: "pet${widget.index}",
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _adoptionButton(),
                _likeButton(),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  _likeButton() {
    return const Icon(
      Icons.favorite_outline_rounded,
      size: 35,
    );
  }

  _adoptionButton() {
    final spacer = SizedBox(width: context.width * .02);
    return InkWell(
      onTap: () {},
      child: Container(
        height: context.height * .06,
        width: context.width * .7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.height * .04),
          color: AppColor.orange,
        ),
        padding: EdgeInsets.symmetric(horizontal: context.width * .05),
        child: Row(
          children: [
            spacer,
            Text(
              "Adopt Pet",
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
          ],
        ),
      ),
    );
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
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "8 Feb. 2023",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
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
                      color: Colors.black,
                    ),
              ),
              Text(
                widget.pet.breed,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.grey),
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
        color: Colors.amber.shade200,
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
            painter: CustomVerticalDivider(),
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
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  _desciption() {
    const x =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, justo ac ultrices ultricies, nisl nunc ultrices dolor, quis aliquam nisl nunc ut nisl. Sed euismod, justo ac ultrices ultricies, nisl nunc ultrices dolor, quis aliquam nisl nunc ut nisl.";

    final style = Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey);
    if (x.length > 130) {
      return Text.rich(
        TextSpan(
          text: x.substring(0, 130),
          style: style,
          children: [
            TextSpan(
              text: "...Read More",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
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

class CustomVerticalDivider extends CustomPainter {
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
