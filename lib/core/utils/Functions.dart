import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'TextStyles.dart';

void NavigateTo(BuildContext context, Widget widget) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final opacityAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: opacityAnimation,
          child: child,
        );
      },
    ),
  );
}

void toast(BuildContext context, String text, ToastState state) {
  Icon icon;
  switch (state) {
    case ToastState.Success:
      icon = const Icon(FontAwesomeIcons.check, color: Colors.white);
      break;
    case ToastState.Error:
      icon = const Icon(Icons.error, color: Colors.white);
      break;
    case ToastState.Warning:
      icon = const Icon(Icons.warning, color: Colors.white);
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 5.0.w), // Adjust the spacing as needed
          Expanded(
            child: Center(
                child: Text(
              text,
              style: getTextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp),
            )),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0.w),
      ),
      backgroundColor: chooseToastColor(state),
      width: 250.w,
    ),
  );
}

enum ToastState { Success, Error, Warning }

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.Success:
      color = Colors.green;
      break;
    case ToastState.Error:
      color = Colors.red;
      break;
    case ToastState.Warning:
      color = Colors.amber;
      break;
  }
  return color;
}
