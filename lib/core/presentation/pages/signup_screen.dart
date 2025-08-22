import 'package:arkroot_todo_app/core/presentation/reverpode_providers/auth_provider.dart';
import 'package:arkroot_todo_app/core/presentation/utils/custom_dialoques.dart';
import 'package:arkroot_todo_app/core/presentation/utils/message_generator.dart';
import 'package:arkroot_todo_app/core/presentation/utils/theme.dart';
import 'package:arkroot_todo_app/core/presentation/widgets/animated_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIXED: Watch signUpNotifierProvider instead of authNotifierProvider
    final signUpState = ref.watch(signUpNotifierProvider);

    // FIXED: Listen to signUpNotifierProvider and handle void return type
    ref.listen(signUpNotifierProvider, (previous, next) {
      if (next is AsyncError) {
        String errorMessage = next.error.toString();

        // Make error messages more user-friendly
      if (errorMessage.contains('email-already-in-use')) {
          errorMessage = MessageGenerator.getMessage('email-already-in-use');
        } else if (errorMessage.contains('weak-password')) {
          errorMessage = MessageGenerator.getMessage('weak-password');
        } else if (errorMessage.contains('invalid-email')) {
          errorMessage = MessageGenerator.getMessage('invalid-email');
        } else if (errorMessage.contains('network-request-failed')) {
          errorMessage = MessageGenerator.getMessage('network-request-failed');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      } else if (next is AsyncData) {
        // FIXED: For void return type, just check if it's AsyncData (success)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully Registered! Please sign in."),
            backgroundColor: Colors.green,
          ),
        );
        CustomDialogs.showSuccessDialog(
          context: context,
          title: "Welcome Aboard!",
          message:
              "Your account has been created successfully. Please sign in with your new credentials to get started.",
              buttonText: "Sign In",
              barrierDismissible: false,
              onPressed: () {
                Navigator.of(context).pop();
                context.go("/home");
              },
        );
      }
    });

    // FIXED: Check loading state from signUpNotifierProvider
    final isLoading = signUpState is AsyncLoading;

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
                      MessageGenerator.getMessage("signup-title"),
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: Colors.white, fontSize: 45.sp),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Name Field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      style: Theme.of(context).textTheme.labelSmall,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: appColors.disableBgColor),
                        hintText: MessageGenerator.getLabel('John Doe'),
                        label: Text(
                          MessageGenerator.getLabel('type in full name'),
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(fontSize: 13.sp),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: appColors.inputBgFill,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
                        if (!nameRegex.hasMatch(value.trim())) {
                          return 'Enter a valid name';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 8.h),

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
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
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

                  SizedBox(height: 8.h),

                  // Confirm Password Field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.labelSmall,
                      textInputAction: TextInputAction.done,
                      enabled: !isLoading,
                      onFieldSubmitted: (_) => _handleSignUp(),
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(color: appColors.disableBgColor),
                        hintText: MessageGenerator.getLabel('user@123'),
                        label: Text(
                          MessageGenerator.getLabel('confirm password'),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: appColors.inputBgFill,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Sign Up Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedClickableTextContainer(
                      title:
                          isLoading
                              ? "Creating account..."
                              : MessageGenerator.getLabel('Sign Up'),
                      iconSrc: '',
                      isActive: !isLoading,
                      bgColor: appColors.pleasantButtonBg,
                      bgColorHover: appColors.pleasantButtonBgHover,
                      press: isLoading ? () {} : _handleSignUp,
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
                  SizedBox(height: 10.h),

                  // Sign In Link
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.labelSmall,
                      children: <TextSpan>[
                        TextSpan(
                          text: MessageGenerator.getLabel(
                            "Already have an account? ",
                          ),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        TextSpan(
                          text: MessageGenerator.getLabel('Sign In'),
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: Colors.white),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  if (!isLoading) {
                                    context.go("/login");
                                  }
                                },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final name = _nameController.text.trim();
      final password = _passwordController.text.trim();

      print('Attempting signup with: Name=$name, Email=$email');

      // Call your auth provider's signUp method
      ref.read(signUpNotifierProvider.notifier).signUp(name, email, password);
    }
  }
}
