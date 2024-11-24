import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:quickbite/admin/login.dart';
import 'package:quickbite/pages/onboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String publishableKey =
      'pk_test_51QLlzGHrR7KIk4IWu7KnyRGppHi2WaQvmMrsIFY8qs965lfKpjr0WwmzU0wHB3O8314GN1pfZyVm5pZ26cMBusq7005fj225VH';
  Stripe.publishableKey = publishableKey;

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickBite App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AdminLogin(),
      //home: const Onboard(),
    );
  }
}
