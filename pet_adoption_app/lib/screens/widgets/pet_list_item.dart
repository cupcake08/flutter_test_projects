import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/screens/screens.dart';
import 'package:pet_adoption_app/utils/utils.dart';

class PetListItemWidget extends StatelessWidget {
  const PetListItemWidget({
    super.key,
    required this.pet,
  });
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PetDetailScreen(pet: pet),
            transitionDuration: 400.ms,
            reverseTransitionDuration: 200.ms,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(0),
              elevation: 5,
              child: Hero(
                tag: "pet${pet.id}",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: pet.image,
                    fit: BoxFit.cover,
                    height: context.height / 3,
                    width: context.width,
                    placeholder: (context, url) => const Icon(
                      Icons.pets,
                      size: 50,
                      color: AppColor.orange,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                      ),
                      Text(
                        pet.breed,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _getPetIconBasedOnGender(),
                  color: AppColor.orange,
                  size: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPetIconBasedOnGender() {
    switch (pet.gender) {
      case Gender.male:
        return Icons.male_rounded;
      case Gender.female:
        return Icons.female_rounded;
    }
  }
}
