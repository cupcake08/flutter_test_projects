import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pet_adoption_app/providers/providers.dart';
import 'package:pet_adoption_app/screens/widgets/widgets.dart';
import 'package:pet_adoption_app/utils/delegates/search_delagate.dart';
import 'package:pet_adoption_app/utils/utils.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _showFloatingActionButton;
  late final AnimationController _animationController;
  late final AnimationController _listController;

  bool isDarkMode = false;

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

    // pagination
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
      final provider = context.read<PetsNotifier>();
      bool hasMore = false;
      int skip = 0;

      switch (provider.currentCategorySelectedIndex) {
        case 0:
          hasMore = provider.hasMoreCats;
          skip = provider.cats.length;
        case 1:
          hasMore = provider.hasMoreDogs;
          skip = provider.dogs.length;
        case 2:
          hasMore = provider.hasMoreBirds;
          skip = provider.birds.length;
        case 3:
          hasMore = provider.hasMoreFishes;
          skip = provider.fishes.length;
      }

      if (!provider.gettingMorePets && hasMore) {
        provider.setResetTheAnimationController = false;
        provider.getPetsPagination(skip);
      }
    }
  }

  @override
  void didChangeDependencies() {
    isDarkMode = context.read<ThemeProvider>().themeMode == ThemeMode.dark;
    super.didChangeDependencies();
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
            title: Text(
              "HOME",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchSection(),
              SlideTransition(
                position: Tween(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.ease,
                  ),
                ),
                child: FadeTransition(
                  opacity: _animationController,
                  child: Text(
                    "Categories",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              SizedBox(height: context.height * .01),
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

  _searchSection() {
    return SlideTransition(
      position: Tween(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.ease,
        ),
      ),
      child: FadeTransition(
        opacity: _animationController,
        child: Container(
          height: context.height * .06,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              showSearch(
                context: context,
                delegate: PetSearchDelegate(),
              );
            },
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Search For Pets",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loadItems() {
    return Selector<PetsNotifier, (int, bool, int)>(
      selector: (p0, p1) => (
        p1.currentCategorySelectedIndex,
        p1.gettingPets,
        _getTheLength(),
      ),
      builder: (context, data, _) {
        if (data.$2) {
          return const Center(child: CircularProgressIndicator());
        }
        final provider = context.read<PetsNotifier>();
        final pets = provider.getPetList(data.$1);
        if (provider.resetTheAnimationController) {
          _listController.reset();
        }
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
                child: PetListItemWidget(pet: pets[index]),
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
        onPressed: () {
          final provider = context.read<ThemeProvider>();
          AppInit.setThemeMode(provider.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
          provider.toggleTheme(provider.themeMode == ThemeMode.dark ? false : true);
          context.showSnackBar(provider.themeMode == ThemeMode.dark ? "Dark Mode" : "Light Mode");
        },
        icon: Icon(
          Icons.switch_access_shortcut,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    ];
  }

  _getTheLength() {
    final provider = context.read<PetsNotifier>();
    switch (provider.currentCategorySelectedIndex) {
      case 0:
        return provider.cats.length;
      case 1:
        return provider.dogs.length;
      case 2:
        return provider.birds.length;
      case 3:
        return provider.fishes.length;
      default:
        return 0;
    }
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
