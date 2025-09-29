import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'mobile/screens/bhw_login.dart';
import 'mobile/screens/bhw_dashboard.dart';
import 'mobile/screens/bhw_forgot_password.dart';
import 'mobile/screens/bhw_splash_screen.dart';
import 'web/screens/mho_login.dart';
import 'web/screens/mho_dashboard.dart';
import 'web/screens/mho_forgot_password.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('authBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box('authBox');
    final token = authBox.get('token');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CoRAS",
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home:
          kIsWeb
              ? const MhoLogin()
              : (token != null ? const BhwDashboard() : const BhwSplash()),
      routes: {
        "/bhwLogin": (_) => const BhwLogin(),
        "/bhwDashboard": (_) => const BhwDashboard(),
        "/mhoDashboard": (_) => const MhoDashboard(),
        "/bhwForgotPassword": (_) => const BhwForgotPassword(),
        "/mhoForgotPassword": (_) => const MhoForgotPassword(),
      },
    );
  }
}
