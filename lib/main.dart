import 'package:festival_post_app/controllers/festival_controller.dart';
import 'package:festival_post_app/utils/my_page_route_utils.dart';
import 'package:festival_post_app/views/screens/festival_page.dart';
import 'package:festival_post_app/views/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FestivalController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      routes: {
        MyPageRoute.home: (context) => const HomePage(),
        MyPageRoute.festival: (context) => const FestivalPage(),
      },
    );
  }
}
