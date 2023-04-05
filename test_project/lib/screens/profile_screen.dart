import 'package:flutter/material.dart';
import 'package:test_project/models/models.dart';
import 'package:test_project/models/shared_profile.dart';
import 'package:test_project/screens/home_screen.dart';
import 'package:test_project/util/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.user,
  });
  final User user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    const double radius = 15.0;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Profile details",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile header
                Container(
                  height: context.height * .1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: AppColors.secondaryBlue,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      ProfileAvatar(user: widget.user),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            widget.user.gender == Gender.male ? "Male" : "Female",
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: context.height * .1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: AppColors.primayBlue,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Share your patient profile",
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primayGreen,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          "Share profile",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // patient details
                Text(
                  "Patient Details",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: DetailBox(user: widget.user),
                ),
                const SizedBox(height: 20),
                Text(
                  "Shared Profile",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ListView.builder(
                  itemCount: sharedProfiles.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final profile = sharedProfiles[index];
                    final minute = Common.twoDigit(profile.date.minute);
                    final hour = Common.twoDigit(profile.date.hour);
                    final shift = profile.date.hour >= 12 ? "PM" : "AM";
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius),
                              color: AppColors.secondaryBlue,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "${Common.getMonth(profile.date.month)} ${Common.twoDigit(profile.date.day)}",
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.primayBlue),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "$hour:$minute $shift",
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.primayBlue),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.user.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                "${profile.viewCount} views",
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.primayGreen),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailBox extends StatefulWidget {
  const DetailBox({
    super.key,
    required this.user,
  });
  final User user;

  @override
  State<DetailBox> createState() => _DetailBoxState();
}

class _DetailBoxState extends State<DetailBox> {
  Widget _getRow(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black45),
        ),
        Text(
          data,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.mainTextColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dob = widget.user.dob;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getRow("Date of birth", "${Common.twoDigit(dob.day)}-${Common.twoDigit(dob.month)}-${dob.year}"),
        _getRow("City", widget.user.city),
        _getRow("Country", widget.user.country),
      ],
    );
  }
}
