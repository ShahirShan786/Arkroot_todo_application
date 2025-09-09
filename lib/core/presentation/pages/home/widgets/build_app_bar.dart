import 'package:Arkroot/core/presentation/reverpode_providers/auth_provider.dart';
import 'package:Arkroot/core/presentation/utils/message_generator.dart';
import 'package:Arkroot/core/presentation/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar buildAppBar(BuildContext context , WidgetRef ref) {
    return AppBar(
      title: Text(
        MessageGenerator.getMessage("arkroot"),
        style: GoogleFonts.poppins(
          color: appColors.textColor,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
      backgroundColor: appColors.appBarcolor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () => showSignOutDialog(context , ref),
          icon: const Icon(Icons.logout, color: Colors.white),
          tooltip: 'Sign Out',
        ),
      ],
    );

    
  }


   void showSignOutDialog(BuildContext context , WidgetRef ref ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appColors.inputBgFill,
          title: const Text("Sign Out", style: TextStyle(color: Colors.white)),
          content: Text(
            "Are you sure you want to sign out?",
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[400])),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleSignOut(context , ref );
              },
              child: Text("Sign Out", style: TextStyle(color: Colors.red[400])),
            ),
          ],
        );
      },
    );
  }

  void _handleSignOut(BuildContext context , WidgetRef ref) {
    ref.read(authNotifierProvider.notifier).signOut();
  }