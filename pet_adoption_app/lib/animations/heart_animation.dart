import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/providers/pets_notifier.dart';
import 'package:pet_adoption_app/utils/utils.dart';
import 'package:provider/provider.dart';

class HeartAnimation extends StatefulWidget {
  const HeartAnimation({super.key, required this.pet});
  final Pet pet;

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation> with TickerProviderStateMixin {
  // [_controller] is for inner animation effect.
  late AnimationController _controller;

  // [_outerBoxController] is outer circle animation controller.
  late AnimationController _outerBoxController;

  // inner circle animation
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 400),
    );

    _outerBoxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: const ElasticOutCurve(0.8),
    );

    if (widget.pet.isFavorite) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _outerBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.status == AnimationStatus.dismissed ? _controller.forward() : _controller.reverse();
        if (_controller.status == AnimationStatus.forward) {
          context.showSnackBar("Added to favorites!");
        }
        context.read<PetsProvider>().markPetAsFavorite(widget.pet);
      },
      onTapDown: (details) => _outerBoxController.forward(),
      onTapUp: (details) => _outerBoxController.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 1 - _outerBoxController.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.iconColor,
                      width: 2.5,
                    ),
                  ),
                  width: context.width * .13,
                  height: context.width * .13,
                ),
              ),
              _controller.status == AnimationStatus.dismissed
                  ? const Icon(
                      Icons.favorite,
                      size: 30,
                      color: AppColor.iconColor,
                    )
                  :
                  // another element
                  Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.iconColor,
                          ),
                          width: (context.width * .12 - 10) * _animation.value,
                          height: (context.width * .12 - 10) * _animation.value,
                        ),
                        Icon(
                          Icons.favorite,
                          size: 25 * _animation.value,
                          color: Colors.white,
                        )
                      ],
                    ),
            ],
          );
        },
      ),
    );
  }
}
