
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/utils/Functions.dart';
import '../../../../core/utils/TextStyles.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/widget/Widgets.dart';
import '../../../login/presentaion/ui/LoginScreen.dart';
import '../cubit/RegisterCubit.dart';
import '../cubit/RegisterState.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    // final loginCubit = BlocProvider.of<LoginCubit>(context);

    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            NavigateTo(context, const LoginScreen());
          } else if (state is RegisterFailure) {
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
                    height: 80.h,
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
                    padding:
                        EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 10.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomTextFormField(
                                  labelText: "First Name",
                                  inputType: TextInputType.text,
                                  controller: firstNameController,
                                  icon: Icon(FontAwesomeIcons.user,
                                      color: mainColor),
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "First Name";
                                    }
                                    return null;
                                  },
                                  suffixFun: () {},
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                CustomTextFormField(
                                  labelText: "Last Name",
                                  inputType: TextInputType.text,
                                  controller: lastNameController,
                                  icon: Icon(FontAwesomeIcons.user,
                                      color: mainColor),
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Last Name";
                                    }
                                    return null;
                                  },
                                  suffixFun: () {},
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                CustomTextFormField(
                                  labelText: "Phone Number",
                                  // hintText: "اسم المستخدم",
                                  inputType: TextInputType.phone,
                                  controller: phoneController,
                                  icon: Icon(FontAwesomeIcons.phone,
                                      color: mainColor),
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Phone Number";
                                    }
                                    return null;
                                  },
                                  suffixFun: () {},
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                CustomTextFormField(
                                  labelText: "Email",
                                  // hintText: "اسم المستخدم",
                                  inputType: TextInputType.emailAddress,
                                  controller: emailController,
                                  icon: Icon(FontAwesomeIcons.envelope,
                                      color: mainColor),
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email";
                                    }
                                    return null;
                                  },
                                  suffixFun: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
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
                                      return "password";
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
                                SizedBox(height: 8.h),
                                CustomTextFormField(
                                  labelText: "confirmation password",
                                  inputType: TextInputType.text,
                                  controller: confirmPasswordController,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: mainColor,
                                  ),
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "confirmation password";
                                    }
                                    return null;
                                  },
                                  onSubmit: (value) {
                                    if (formKey.currentState?.validate() ==
                                        true) {}
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            state is! RegisterLoading
                                ? SizedBox(
                                    width: 250.w,
                                    height: 40.h,
                                    child: CustomButton(
                                      color: mainColor,
                                      onPressed: () {
                                        if (formKey.currentState?.validate() ==
                                            true) {
                                          BlocProvider.of<RegisterCubit>(
                                                  context)
                                              .registerUser(
                                                  firstName:
                                                      firstNameController.text,
                                                  lastName:
                                                      lastNameController.text,
                                                  phone: phoneController.text,
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                  confirmPassword:
                                                      confirmPasswordController
                                                          .text);
                                        }
                                      },
                                      text: "Register",
                                    ),
                                  )
                                : const Center(child: CustomLoadingIndicator()),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: getTextStyle(
                                      color: greyColor, fontSize: 14.sp),
                                  children: [
                                    TextSpan(
                                      text: "Login",
                                      style: getTextStyle(
                                        color: mainColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
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
}
