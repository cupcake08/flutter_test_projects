import 'package:flutter/material.dart';

class InternetError extends StatelessWidget {
  final void Function()? onTap;
  final double height;
  final String errorMsg;
  final double? fontSize;
  final Color errorMsgColor;

  const InternetError({
    Key? key,
    this.onTap,
    this.fontSize,
    required this.height,
    required this.errorMsg,
    this.errorMsgColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: height),
              Icon(
                Icons.network_check,
                size: fontSize != null ? 30.0 : 50.0,
                color: errorMsgColor,
              ),
              Text(
                errorMsg,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              onTap != null
                  ? Text(
                      "click here to retry",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: height),
            ],
          ),
        ),
      ),
    );
  }
}
