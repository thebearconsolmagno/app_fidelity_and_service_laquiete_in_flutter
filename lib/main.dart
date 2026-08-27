
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_provider.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const LaQuieteApp(),
    ),
  );
}

class LaQuieteApp extends StatelessWidget {
  const LaQuieteApp({super.key});

  Color _parseColor(String? hexColor, Color fallback) {
    if (hexColor == null || hexColor.isEmpty) return fallback;
    try {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    } catch (e) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, child) {
        final primary = _parseColor(app.theme?.primaryColor, const Color(0xFF10B981));
        final secondary = _parseColor(app.theme?.secondaryColor, const Color(0xFF1E3A8A));

        return MaterialApp(
          title: app.theme?.companyName ?? 'La Quiete',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primary,
              primary: primary,
              secondary: secondary,
            ),
            textTheme: GoogleFonts.interTextTheme(),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic
              ),
            ),
          ),
          home: app.isLoading && app.theme == null
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : app.token == null ? const LoginPage() : const HomePage(),
        );
      },
    );
  }
}
