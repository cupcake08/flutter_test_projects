import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pet_adoption_app/models/pet.dart';
import 'package:pet_adoption_app/providers/pets_notifier.dart';
import 'package:pet_adoption_app/screens/home/pet_detail_screen.dart';
import 'package:pet_adoption_app/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.animationController});
  final AnimationController animationController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _showFloatingActionButton;
  late final AnimationController _animationController;
  late final AnimationController _listController;

  @override
  void initState() {
    super.initState();
    AppInit.setCanIFillDataToIsar(false);
    _animationController = AnimationController(vsync: this, duration: 800.ms);
    _listController = AnimationController(vsync: this, duration: 800.ms);
    _showFloatingActionButton = ValueNotifier(false);
    _scrollController = ScrollController();
    final provider = context.read<PetsNotifier>();
    if (!provider.gettingPets && provider.cats.isEmpty) {
      provider.setCurrentCategorySelectedIndex(0, notify: false);
    }
    _scrollController.addListener(_scrollListener);
    _animationController.forward();
  }

  _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      _showFloatingActionButton.value = true;
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent) {
      _showFloatingActionButton.value = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.animationController.reset();
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(context.width, kToolbarHeight),
          child: SlideTransition(
            position: Tween(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOut,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              title: const Text("HOME", style: TextStyle(color: Colors.black)),
              actions: _appBarActions(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SlideTransition(
                  position: Tween(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.ease,
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Row(
                      children: [
                        Text(
                          "Categories",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text("See All >>"),
                        ),
                      ],
                    ),
                  ),
                ),
                const CategorySelectionWidget(),
                const Divider(),
                _loadItems(),
              ],
            ),
          ),
        ),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }

  _loadItems() {
    return Selector<PetsNotifier, (int, bool)>(
      selector: (p0, p1) => (p1.currentCategorySelectedIndex, p1.gettingPets),
      builder: (context, data, _) {
        if (data.$2) {
          return const Center(child: CircularProgressIndicator());
        }
        final pets = context.read<PetsNotifier>().getPetList(data.$1, 0);
        _listController.reset();
        _listController.forward();
        return ListView.builder(
          itemCount: pets.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final start = (index % 6 == 0) ? 0.0 : ((index % 6) + 4) / 12;
            return SlideTransition(
              position: Tween(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
                CurvedAnimation(
                  parent: _listController,
                  curve: Interval(
                    start,
                    1.0,
                    curve: Curves.ease,
                  ),
                ),
              ),
              child: FadeTransition(
                opacity: _listController,
                child: PetListItemWidget(
                  index: index,
                  pet: pets[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  _floatingActionButton() {
    return ValueListenableBuilder(
      valueListenable: _showFloatingActionButton,
      builder: (context, showButton, child) {
        return AnimatedSwitcher(
          duration: 150.ms,
          child: showButton ? child : const SizedBox.shrink(),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.ease,
            ),
            child: child,
          ),
        );
      },
      child: FloatingActionButton(
        backgroundColor: AppColor.orange,
        foregroundColor: Colors.white,
        onPressed: () {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: 500.ms,
            curve: Curves.easeOutBack,
          );
        },
        child: const Icon(Icons.arrow_upward_rounded),
      ),
    );
  }

  _appBarActions() {
    return [
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.switch_access_shortcut,
          color: Colors.black,
        ),
      ),
    ];
  }
}

class CategorySelectionWidget extends StatefulWidget {
  const CategorySelectionWidget({super.key});

  @override
  State<CategorySelectionWidget> createState() => _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final int count = 10;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: 800.ms);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PetsNotifier, int>(
        selector: (p0, p1) => p1.currentCategorySelectedIndex,
        builder: (context, value, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _slideTransition(
                CategoryWidget(
                  image: "assets/cat-min.jpg",
                  isSelected: value == 0,
                  title: "Cats",
                  index: 0,
                ),
                0.0,
              ),
              _slideTransition(
                CategoryWidget(
                  image: "assets/dog-min.jpg",
                  isSelected: value == 1,
                  title: "Dogs",
                  index: 1,
                ),
                2 / count,
              ),
              _slideTransition(
                CategoryWidget(
                  image: "assets/bird-min.jpg",
                  isSelected: value == 2,
                  title: "Birds",
                  index: 2,
                ),
                4 / count,
              ),
              _slideTransition(
                CategoryWidget(
                  image: "assets/fish-min.jpg",
                  isSelected: value == 3,
                  title: "Fish",
                  index: 3,
                ),
                6 / count,
              ),
            ],
          );
        });
  }

  _slideTransition(Widget child, double beginInterval) {
    final animation = Tween<Offset>(
      begin: const Offset(4, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          beginInterval,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
    return SlideTransition(
      position: animation,
      child: FadeTransition(
        opacity: _animationController,
        child: child,
      ),
    );
  }
}

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

class PetListItemWidget extends StatelessWidget {
  const PetListItemWidget({
    super.key,
    required this.index,
    required this.pet,
  });
  final int index;
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PetDetailScreen(index: index, pet: pet),
          ),
        );
      },
      child: Container(
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
              child: Hero(
                tag: "pet$index",
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
