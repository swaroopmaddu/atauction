import 'package:atauction/screens/addProduct/addproduct.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:atauction/screens/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const MaterialColor primary = const MaterialColor(
    0xFF00BFA6,
    const <int, Color>{
      50: const Color(0xFF00BFA6),
      100: const Color(0xFF00BFA6),
      200: const Color(0xFF00BFA6),
      300: const Color(0xFF00BFA6),
      400: const Color(0xFF00BFA6),
      500: const Color(0xFF00BFA6),
      600: const Color(0xFF00BFA6),
      700: const Color(0xFF00BFA6),
      800: const Color(0xFF00BFA6),
      900: const Color(0xFF00BFA6),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'At Auction',
      theme: ThemeData(
        accentColor: Colors.white,
        primaryColor: Color.fromRGBO(0, 191, 166, 1),
        primarySwatch: primary,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/newProduct': (context) => AddProduct()
      },
    );
  }
}
