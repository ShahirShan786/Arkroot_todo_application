import 'package:arkroot_todo_app/core/presentation/utils/message_generator.dart';
import 'package:arkroot_todo_app/core/presentation/utils/theme.dart';
import 'package:arkroot_todo_app/core/presentation/widgets/animated_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 85.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    MessageGenerator.getMessage("login-title"),
                    // "hello",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 45.sp,
                    ),
                  ),
                ),

                SizedBox(height: 50.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context).textTheme.labelSmall,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: appColors.disableBgColor),
                      hintText: MessageGenerator.getLabel('user@domain.com'),
                      label: Text(
                        MessageGenerator.getLabel('type in email'),
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(fontSize: 13.sp),
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: appColors.inputBgFill,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    style: Theme.of(context).textTheme.labelSmall,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      // submitCredentials();
                    },
                    decoration: InputDecoration(
                      hintStyle: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: appColors.disableBgColor),
                      hintText: MessageGenerator.getLabel('user@123'),
                      label: Text(
                        MessageGenerator.getLabel('type in password'),
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(),
                      ),
                      prefixIcon: const Icon(Icons.password_outlined),
                      filled: true,
                      fillColor: appColors.inputBgFill,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedClickableTextContainer(
                    title: MessageGenerator.getLabel('Sign In'),
                    iconSrc: '',
                    isActive: false,
                    bgColor: appColors.pleasantButtonBg,
                    bgColorHover: appColors.pleasantButtonBgHover,
                    press: () {
                      // submitCredentials();
                    },
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 2,
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 5.w,
                        endIndent: 5.w,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),

                    Text("OR"),
                    Expanded(
                      child: Divider(
                        indent: 5.w,
                        endIndent: 5.w,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedClickableTextContainer(
                    title: MessageGenerator.getLabel('google-sign-in'),
                    iconSrc: 'assets/svg/google.svg',
                    isActive: false,
                    bgColor: appColors.pleasantButtonBg,
                    bgColorHover: appColors.pleasantButtonBgHover,
                    press: () {
                      // submitCredentials();
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(),
                    children: <TextSpan>[
                      TextSpan(),
                      TextSpan(
                        text: MessageGenerator.getLabel(
                          "Don't have an account?",
                        ),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                context.go("/forgotPassword");
                              },
                      ),
                      TextSpan(
                        text: MessageGenerator.getLabel('Sign Up'),
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Colors.white),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                context.go("/forgotPassword");
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
