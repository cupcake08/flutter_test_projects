import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_project/models/models.dart';
import 'package:test_project/util/utils.dart';
import 'package:test_project/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.currentUser,
    required this.consultants,
    required this.patients,
  });
  final User currentUser;
  final List<Consultant> consultants;
  final List<User> patients;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabBarController;
  late final ValueNotifier _tabNotifier;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabNotifier = ValueNotifier(0);
    _tabs = [
      EnquiriesWidget(enquiries: widget.patients),
      const ReportsWidget(reports: []),
    ];
    _tabBarController = TabController(length: 2, vsync: this);
    _tabBarController.addListener(() {
      _tabNotifier.value = _tabBarController.index;
    });
  }

  @override
  void dispose() {
    _tabBarController.removeListener(() {
      _tabNotifier.value = _tabBarController.index;
    });
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // profile header
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ProfileAvatar(user: widget.currentUser, applyBorder: false),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // upper light test
                        Text(
                          "Welcome Back",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.grey),
                        ),
                        Text(
                          widget.currentUser.name,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu),
                )
              ],
            ),
            const SizedBox(height: 20),
            const HeadlineHelperWidget(title: "Upcoming consultants"),
            SizedBox(
              height: 200,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.consultants.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ConsultantWidget(
                    consultant: widget.consultants[index],
                    leftPadding: index != 0,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const HeadlineHelperWidget(title: "patient profiles"),
            SizedBox(
              height: 80,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.patients.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return index == 0
                      ? CircleAvatar(
                          radius: 25.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.add,
                              size: 35,
                            ),
                          ),
                        )
                      : ProfileAvatar(
                          user: widget.patients[index - 1],
                          applyBorder: false,
                        );
                },
              ),
            ),
            // tab bar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60 / 2),
                color: AppColors.secondaryBlue,
              ),
              height: 60,
              child: TabBar(
                controller: _tabBarController,
                indicator: TabBarInd(),
                unselectedLabelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
                labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                tabs: const [
                  Tab(text: "Last Enquiries"),
                  Tab(text: "Reports"),
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _tabNotifier,
              builder: (context, value, _) => _tabs[value],
            ),
          ],
        ),
      ),
    );
  }
}

class ReportsWidget extends StatelessWidget {
  const ReportsWidget({
    super.key,
    required this.reports,
  });
  final List<String> reports;

  @override
  Widget build(BuildContext context) {
    return reports.isEmpty
        ? const Center(
            child: Text("No reports for now"),
          )
        : ListView.builder(
            itemCount: reports.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Text(
                  reports[index],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            },
          );
  }
}

class EnquiriesWidget extends StatelessWidget {
  const EnquiriesWidget({super.key, required this.enquiries});
  final List<User> enquiries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: enquiries.length - 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final user = enquiries[index + 1];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 70,
          width: context.width,
          child: Row(
            children: [
              const ColoredBox(
                color: AppColors.primayGreen,
                child: SizedBox(height: 50, width: 3),
              ),
              ProfileAvatar(
                user: user,
                applyBorder: false,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "video consultancy",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TabBarInd extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => TabBarIndicator();
}

class TabBarIndicator extends BoxPainter {
  final Paint _paint;

  TabBarIndicator() : _paint = Paint()..color = AppColors.primayBlue;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.save();
    final size = configuration.size;
    size?.log();
    final center = offset + Offset(size!.width / 2, size.height / 2);
    final h = size.height - 20;
    final w = size.width - 20;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: w, height: h),
        Radius.circular(h / 2),
      ),
      _paint,
    );

    final List<Offset> points = [
      Offset(center.dx - 20, h),
      Offset(center.dx + 20, h),
      Offset(center.dx, h + 17),
    ];
    final Path path = Path();
    path.addPolygon(points, true);
    canvas.drawPath(path, _paint);
    canvas.restore();
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.user,
    this.radius = 25.0,
    this.applyBorder = true,
  });
  final User user;
  final double radius;
  final bool applyBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: applyBorder
          ? const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primayBlue,
            )
          : null,
      padding: applyBorder ? const EdgeInsets.all(3) : null,
      child: CircleAvatar(
        radius: radius,
        foregroundImage: NetworkImage(user.imageUrl),
      ),
    );
  }
}

class HeadlineHelperWidget extends StatelessWidget {
  const HeadlineHelperWidget({
    required this.title,
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward_sharp),
        )
      ],
    );
  }
}
