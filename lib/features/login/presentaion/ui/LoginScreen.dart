
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/utils/Functions.dart';
import '../../../../core/utils/TextStyles.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/widget/Widgets.dart';
import '../../../home_screen/presentation/ui/HomeScreen.dart';
import '../../../register/presentaion/ui/RegisterScreen.dart';
import '../cubit/LoginCubit.dart';
import '../cubit/LoginState.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            saveFCMToken();
            NavigateTo(context, const UserListScreen());
          } else if (state is LoginFailure) {
            toast(context, state.errorMessage, ToastState.Error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 150.h,
                    // color: const Color(0xFF002141),
                    child: Center(
                      child: Image.asset(
                        "assets/images/karta.png",
                        width: 200.w,
                        height: 80.h,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: getTextStyle(color: darkGrey, fontSize: 24.sp),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Welcome back, we missed you!',
                          style: getTextStyle(
                              color: greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomTextFormField(
                                  labelText: "Email",
                                  inputType: TextInputType.emailAddress,
                                  controller: emailController,
                                  icon: Icon(FontAwesomeIcons.envelope,
                                      color: mainColor),
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "enter your email";
                                    }
                                    final emailRegex =
                                        RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                    if (!emailRegex.hasMatch(value)) {
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                  suffixFun: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomTextFormField(
                                  labelText: "password",
                                  inputType: TextInputType.text,
                                  controller: passwordController,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: mainColor,
                                  ),
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password is required";
                                    }
                                    if (value.length < 6) {
                                      return "Password must be at least 6 characters long";
                                    }
                                    return null;
                                  },
                                  onSubmit: (value) {
                                    if (formKey.currentState?.validate() ==
                                        true) {
                                      // loginCubit.userLogin(
                                      //     userName.text, password.text);
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            state is! LoginLoading
                                ? SizedBox(
                                    width: 250.w,
                                    height: 40.h,
                                    child: CustomButton(
                                      color: mainColor,
                                      onPressed: () {
                                        if (formKey.currentState?.validate() ==
                                            true) {
                                          BlocProvider.of<LoginCubit>(context)
                                              .loginUser(emailController.text,
                                                  passwordController.text);
                                        }
                                      },
                                      text: "login",
                                    ),
                                  )
                                : const Center(child: CustomLoadingIndicator()),
                            SizedBox(
                              height: 10.h,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Forgot your password?",
                                  style: getTextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  width: "Forgot your password?".length * 7.5.w,
                                  height: 1.h,
                                  color: Colors.grey.shade700,
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don’t have an account?",
                                  style: getTextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Create Account",
                                    style: getTextStyle(
                                      color: mainColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            // Space between button and text
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void saveFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': fcmToken,
      });

      print("fcm token " '$fcmToken');
    }
  }
}
