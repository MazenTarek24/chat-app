import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/TextStyles.dart';
import '../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      ),
      child: Text(
        text,
        style: getTextStyle(
          color: Colors.white,
          fontSize: 18.sp,
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.icon,
    this.validation,
    required this.controller,
    this.suffixFun,
    this.suffix,
    this.isPassword = false,
    this.labelText,
    this.hintText,
    this.onSubmit,
    required this.inputType,
    this.enabled = true,
    this.disabledTextColor,
    this.enabledTextColor,
    this.onChange,
  });

  final String? hintText;
  final bool isPassword;
  final Icon? icon;
  final String? Function(String?)? validation;
  final TextEditingController controller;
  final Function? suffixFun;
  final IconData? suffix;
  final String? labelText;
  final Function? onSubmit;
  final Function? onChange;
  final TextInputType inputType;
  final bool enabled;
  final Color? disabledTextColor;
  final Color? enabledTextColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        onChange?.call(value);
      },
      enabled: enabled,
      keyboardType: inputType,
      style: TextStyle(
        color: enabled ? enabledTextColor : disabledTextColor,
      ),
      // textDirection: TextDirection.rtl,
      onFieldSubmitted: (value) {
        onSubmit?.call(value);
      },
      obscureText: isPassword,
      controller: controller,
      cursorColor: mainColor,
      // textAlign: getTextAlign(context),

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: mainColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        hintTextDirection: TextDirection.rtl,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        filled: true,
        fillColor: Colors.white, // White background color
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: mainColor,
          ),
          borderRadius: BorderRadius.circular(25), // Circular border radius
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: mainColor, // Border color when there's an error
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(25), // Maintain circular radius
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: mainColor, // Border color when focused and has an error
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(25),
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor
              // color: Colors.blue,
              ),
          borderRadius: BorderRadius.circular(25), // Circular border radius
        ),

        prefixIcon: icon,
        suffixIcon: IconButton(
          splashColor: Colors.transparent, // Prevents splash effect on click
          highlightColor:
              Colors.transparent, // Prevents highlight effect on click
          hoverColor: Colors.transparent, // Keeps the hover color transparent
          onPressed: () {
            suffixFun?.call();
          },
          icon: Icon(suffix, color: Colors.black),
        ),
      ),
      validator: validation,
    );
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.w,
      height: 40.h,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 22.w,
            width: 22.w,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
            ),
          ),
          SizedBox(width: 20.w),
          Text("Loading...",
              style: getTextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color color;

  const CustomAppBar({
    super.key,
    required this.height,
    this.color = Colors.blue, // Default color
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
      child: Container(
        color: color, // Background color
        height: height,
        padding: const EdgeInsets.only(left: 20, top: 50),
        alignment: Alignment.topLeft,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
