import 'package:Arkroot/core/presentation/reverpode_providers/auth_provider.dart';
import 'package:Arkroot/core/presentation/utils/message_generator.dart';
import 'package:Arkroot/core/presentation/utils/theme.dart';
import 'package:Arkroot/core/presentation/widgets/animated_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next is AsyncData && next.value != null) {
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go("/home");
        });
      }
    });

    final isLoading = authState is AsyncLoading;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 85.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      MessageGenerator.getMessage("login-title"),
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: Colors.white, fontSize: 45.sp),
                    ),
                  ),
                  SizedBox(height: 50.h),

                  // Email Field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: Theme.of(context).textTheme.labelSmall,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Password Field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.labelSmall,
                      textInputAction: TextInputAction.done,
                      enabled: !isLoading,
                      onFieldSubmitted: (_) => _handleSignIn(),
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: appColors.disableBgColor),
                        hintText: MessageGenerator.getLabel('user@123'),
                        label: Text(
                          MessageGenerator.getLabel('type in password'),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        prefixIcon: const Icon(Icons.password_outlined),
                        filled: true,
                        fillColor: appColors.inputBgFill,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Sign In Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedClickableTextContainer(
                      title:
                          isLoading
                              ? "Signing in..."
                              : MessageGenerator.getLabel('Sign In'),
                      iconSrc: '',
                      isActive: !isLoading,
                      bgColor: appColors.pleasantButtonBg,
                      bgColorHover: appColors.pleasantButtonBgHover,
                      press: isLoading ? () {} : _handleSignIn,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // OR Divider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Divider(
                          indent: 5.w,
                          endIndent: 5.w,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("OR"),
                      ),
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

                  // Google Sign In Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedClickableTextContainer(
                      title: MessageGenerator.getLabel('google-sign-in'),
                      iconSrc: 'assets/svg/google.svg',
                      isActive: !isLoading,
                      bgColor: appColors.pleasantButtonBg,
                      bgColorHover: appColors.pleasantButtonBgHover,
                      press:
                          isLoading
                              ? () {}
                              : () {
                                ref
                                    .read(authNotifierProvider.notifier)
                                    .signInWithGoogle();
                              },
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Sign Up Link
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.labelSmall,
                      children: <TextSpan>[
                        TextSpan(
                          text: MessageGenerator.getLabel(
                            "Don't have an account? ",
                          ),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        TextSpan(
                          text: MessageGenerator.getLabel('Sign Up'),
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: Colors.white),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  if (!isLoading) {
                                    context.go("/signup");
                                  }
                                },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      ref.read(authNotifierProvider.notifier).signIn(email, password);
    }
  }
}
