import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ui_gen_demo/constants/app_constants.dart';
import 'package:ui_gen_demo/pages/homepage/homepage.dart';
import 'package:ui_gen_demo/pages/homepage/chat_view/animated_drawer_wrapper.dart';
import 'package:ui_gen_demo/pages/settings_page/settings_page.dart';
import 'package:ui_gen_demo/services/chat_view_provider.dart';
import 'package:ui_gen_demo/services/widget_service.dart';

import 'package:ui_gen_demo/pages/widget_catalog_page/widget_catalog_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (e) {
    // Fail gracefully
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatViewProvider()),
        ChangeNotifierProvider(create: (_) => WidgetService()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const AnimatedDrawerWrapper(child: Homepage()),
        '/settings': (context) => const SettingsPage(),
        '/widget_catalog': (context) => const WidgetCatalogPage(),
      },
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
