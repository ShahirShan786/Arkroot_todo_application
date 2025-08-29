import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthNavigate();
   
  
  }

  void _checkAuthNavigate()async{
    await   Future.delayed(const Duration(seconds: 3));
      await FirebaseAuth.instance.authStateChanges().first;

    final user = FirebaseAuth.instance.currentUser;

    if(mounted){
      if(user != null){
        context.go('/home');
      }else{
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
        child: Center(
          child: Image.asset(
            "assets/logo/arkroot_logo.png",
            width: 450,
            height: 500,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
