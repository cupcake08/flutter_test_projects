import 'package:flutter/material.dart';
import 'package:pet_adoption_app/utils/extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text("HOME", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.switch_access_shortcut,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text("See All"),
                  ),
                ],
              ),
              const CategorySelectionWidget(),
              const Divider(),
              ListView.builder(
                itemCount: 10,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return const PetListItemWidget();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategorySelectionWidget extends StatelessWidget {
  const CategorySelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CategoryWidget(
          image: "assets/cat.jpg",
          isSelected: false,
          title: "Cats",
        ),
        CategoryWidget(
          image: "assets/dog.jpg",
          isSelected: true,
          title: "Dogs",
        ),
        CategoryWidget(
          image: "assets/bird.jpg",
          isSelected: false,
          title: "Birds",
        ),
        CategoryWidget(
          image: "assets/fish.jpg",
          isSelected: true,
          title: "Fish",
        ),
      ],
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.isSelected,
    required this.image,
    required this.title,
  });
  final String image;
  final bool isSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: Colors.deepPurple) : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
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
    );
  }
}

class PetListItemWidget extends StatelessWidget {
  const PetListItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/cat.jpg",
                fit: BoxFit.cover,
                height: context.height / 4,
                width: context.width,
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
                      "Alexa Cute",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    Text(
                      "Persian Cat",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
