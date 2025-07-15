import 'package:flutter/material.dart';
import 'package:frontend/splash/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  final midtrans = await MidtransSDK.init(
    config: MidtransConfig(
      clientKey: "SB-Mid-client-J1kOJ9Bm7omupZt0",
      merchantBaseUrl: "https://7fcb-182-253-145-197.ngrok-free.app/api/",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        Provider<MidtransSDK?>.value(value: midtrans),
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
          home: const SplashScreen(),
        );
      },
    );
  }
}
