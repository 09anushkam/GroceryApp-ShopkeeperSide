import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase import
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/shop_details_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/product_success_screen.dart';
import 'firebase_options.dart'; // If you are using Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for Web or Mobile
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ShopLocalia',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: {
    '/': (context) => LoginScreen(),
    '/registration': (context) => RegistrationScreen(),
    '/shop-details': (context) => ShopDetailsScreen(),
    '/add-product': (context) => AddProductScreen(products: [], shopId: ''), // Ensure shopId is passed
    '/successScreen': (context) => ProductSuccessScreen(),  // Frame 53
    // Add more routes as needed
    },
        );
    }
}