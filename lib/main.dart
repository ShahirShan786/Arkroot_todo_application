import 'package:arkroot_todo_app/core/presentation/pages/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arkroot_todo_app/core/presentation/navigation/app_router.dart';
import 'package:arkroot_todo_app/core/presentation/utils/di.dart';
import 'package:arkroot_todo_app/core/presentation/utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setPathUrlStrategy();
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      splitScreenMode: true,
      minTextAdapt: false,
      fontSizeResolver: FontSizeResolvers.radius,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router,
          title: "to_do_app",
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          darkTheme: appTheme,
        );
      },
      child: const LoginScreen(),
    );
  }

  static void debugPrint(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }
}
