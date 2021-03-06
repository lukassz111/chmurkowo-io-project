import 'package:chmurkowo/Page/AddImagePage.dart';
import 'package:chmurkowo/Page/GoogleLoginPage.dart';
import 'package:chmurkowo/Page/ErrorAddImage.dart';
import 'package:chmurkowo/Page/SplashPage.dart';
import 'package:chmurkowo/service/AuthService.dart';
import 'package:flutter/material.dart';

import 'Page/MapPage.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService authService = new AuthService();
  await authService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Chmurkowo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashPage(),
        '/': (context) => MapPage(),
        '/login': (context) => GoogleLoginPage(),
        //'/map': (context) => MapPage(),
        '/add_image': (context) => AddImagePage(),
        '/error_add_image': (context) => ErrorAddImage()
      },
    );
  }
}
