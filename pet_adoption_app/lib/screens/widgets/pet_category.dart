import 'package:flutter/material.dart';
import 'package:pet_adoption_app/providers/providers.dart';
import 'package:pet_adoption_app/utils/utils.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.isSelected,
    required this.image,
    required this.title,
    required this.index,
  });
  final String image;
  final bool isSelected;
  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    const double radius = 8.0;
    const borderShift = 3.0;
    return InkWell(
      onTap: () {
        context.read<PetsNotifier>().setCurrentCategorySelectedIndex(index);
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: 100.ms,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: Colors.deepPurple, width: isSelected ? borderShift : 1.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isSelected ? radius - borderShift : radius - 1),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                height: context.width / 5,
                width: context.width / 5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}
