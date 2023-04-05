import 'package:flutter/material.dart';
import 'package:test_project/models/models.dart';
import 'package:test_project/screens/screens.dart';
import 'package:test_project/util/utils.dart';

class ConsultantWidget extends StatefulWidget {
  const ConsultantWidget({
    required this.consultant,
    required this.leftPadding,
    super.key,
  });
  final bool leftPadding;
  final Consultant consultant;

  @override
  State<ConsultantWidget> createState() => _ConsultantWidgetState();
}

class _ConsultantWidgetState extends State<ConsultantWidget> {
  Widget _parseDateTime() {
    final time = widget.consultant.time;
    final minute = _twoDigit(time.minute);
    final hour = _twoDigit(time.hour);
    final month = _getMonth(time.month);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "$hour:$minute",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: widget.consultant.active ? Colors.white : AppColors.primayGreen,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          "${_twoDigit(time.day)} $month",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sept";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return "";
  }

  String _twoDigit(int number) => number < 10 ? "0$number" : number.toString();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: widget.consultant.active ? AppColors.primayBlue : AppColors.secondaryBlue,
      ),
      width: context.width * .45,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(left: widget.leftPadding ? null : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileAvatar(user: users[1]),
              _parseDateTime(),
            ],
          ),
          const Spacer(flex: 2),
          // name
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              widget.consultant.user.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: widget.consultant.active ? Colors.white : null),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              fixedSize: Size(context.width, context.height * .03),
              backgroundColor: widget.consultant.active ? AppColors.primayGreen : Colors.white,
            ),
            child: Text(
              widget.consultant.active ? "Join the call" : "Wait for call",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: widget.consultant.active ? Colors.white : AppColors.primayBlue,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
