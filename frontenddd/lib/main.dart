import 'package:flutter/material.dart';
import 'package:frontenddd/splash/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:midtrans_sdk/midtrans_sdk.dart'; // <-- Dinonaktifkan
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

import 'theme/app_theme.dart';

void main() async {
  // Hanya setup yang tidak butuh UI
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Ecommerce App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.vibrantTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(), // Mulai dari SplashScreen
        );
      },
    );
  }
}
