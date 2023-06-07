import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pet_adoption_app/utils/extensions.dart';
import 'package:pet_adoption_app/utils/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _showFloatingActionButton;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: 800.ms);
    _showFloatingActionButton = ValueNotifier(false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text("HOME", style: TextStyle(color: Colors.black)),
        actions: _appBarActions(),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
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
                    child: const Text("See All >>"),
                  ),
                ],
              ),
              const CategorySelectionWidget(),
              const Divider(),
              _loadItems(),
            ],
          ),
        ),
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  _loadItems() {
    return ListView.builder(
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SlideTransition(
          position: Tween(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index / (index + 10),
                1.0,
                curve: Curves.ease,
              ),
            ),
          ),
          child: FadeTransition(
            opacity: _animationController,
            child: const PetListItemWidget(),
          ),
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
    return GestureDetector(
      onTap: () {
        _animationController.reset();
        _animationController.forward();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _slideTransition(
            const CategoryWidget(
              image: "assets/cat.jpg",
              isSelected: false,
              title: "Cats",
            ),
            0.0,
          ),
          _slideTransition(
            const CategoryWidget(
              image: "assets/dog.jpg",
              isSelected: true,
              title: "Dogs",
            ),
            1 / count,
          ),
          _slideTransition(
            const CategoryWidget(
              image: "assets/bird.jpg",
              isSelected: false,
              title: "Birds",
            ),
            2 / count,
          ),
          _slideTransition(
            const CategoryWidget(
              image: "assets/fish.jpg",
              isSelected: false,
              title: "Fish",
            ),
            3 / count,
          ),
        ],
      ),
    );
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
          curve: Curves.easeOut,
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
  });
  final String image;
  final bool isSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    const double radius = 8.0;
    const borderShift = 3.0;
    return Column(
      children: [
        AnimatedContainer(
          duration: 300.ms,
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
