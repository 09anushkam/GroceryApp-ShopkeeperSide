import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_shop_admin/screens/add_new_service.dart';
import 'package:grocery_shop_admin/screens/add_service.dart';
import 'package:grocery_shop_admin/screens/existing_shop_screen.dart';
import 'screens/login_screen.dart'; // Updated import for login screen
import 'screens/registration_screen.dart'; // Updated import for registration screen
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
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid; // Get current user ID

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
        '/existing-shop': (context) => ExistingShopsScreen(userId: currentUserId!), // Pass userId
        '/add-service': (context) => AddServiceScreen(),
        '/add-new-service': (context) => AddNewServiceScreen(), // Add route for adding new service

      },
    );
  }
}
