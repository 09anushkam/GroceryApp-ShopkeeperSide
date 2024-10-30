// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Assuming you store the shop data in local storage
// import '../widgets/custom_button.dart';
// // import 'product_list_screen.dart'; // Import the ProductListScreen
//
// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }
//
// class _RegistrationScreenState extends State<RegistrationScreen> {
//   bool _hasExistingShop = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkExistingShop();
//   }
//
//   // Check if a shop exists
//   Future<void> _checkExistingShop() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? hasShop = prefs.getBool('hasShop') ?? false; // Assuming 'hasShop' is a flag for shop creation
//     setState(() {
//       _hasExistingShop = hasShop;
//     });
//
//     // Navigate to product list if shop exists
//     if (_hasExistingShop) {
//       // Navigator.pushReplacement(
//       //   context,
//       //   MaterialPageRoute(builder: (context) => ProductListScreen()),
//       // );
//       Navigator.pushReplacementNamed(context, '/product-list');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Row(
//           children: [
//             Image.asset('assets/logo.png', height: 40),
//             SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('ShopLocalia', style: TextStyle(fontSize: 16)),
//                 Text('Empowering Locals, Enhancing Lives', style: TextStyle(fontSize: 12)),
//               ],
//             ),
//           ],
//         ),
//         leading: Icon(Icons.menu),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.location_on),
//             onPressed: () {
//               // Location update action
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text('Shop Registrations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             CustomButton(
//               buttonText: 'Add Shop',
//               onPressed: () {
//                 Navigator.pushNamed(context, '/shop-details');
//               },
//             ),
//             SizedBox(height: 20),
//             CustomButton(
//               buttonText: 'Your Existing Shop',
//               onPressed: () {
//                 Navigator.pushNamed(context, '/existing-shop');
//               },
//             ),
//             SizedBox(height: 40),
//             Text('Service Registrations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             CustomButton(
//               buttonText: 'Add Service',
//               onPressed: () {
//                 // Action to add service
//               },
//             ),
//             SizedBox(height: 20),
//             CustomButton(
//               buttonText: 'Update your Service',
//               onPressed: () {
//                 // Action to update service
//               },
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
//         ],
//         selectedItemColor: Colors.green,
//         onTap: (index) {
//           // Handle bottom navigation actions
//         },
//       ),
//     );
//   }
// }

// Your existing shop code added -

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Assuming you store the shop data in local storage
import '../widgets/custom_button.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _hasExistingShop = false;

  @override
  void initState() {
    super.initState();
    _checkExistingShop();
  }

  // Check if a shop exists
  Future<void> _checkExistingShop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasShop = prefs.getBool('hasShop') ?? false; // Assuming 'hasShop' is a flag for shop creation
    setState(() {
      _hasExistingShop = hasShop;
    });

    // Navigate to product list if shop exists
    if (_hasExistingShop) {
      Navigator.pushReplacementNamed(context, '/product-list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ShopLocalia', style: TextStyle(fontSize: 16)),
                Text('Empowering Locals, Enhancing Lives', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              // Location update action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Shop Registrations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CustomButton(
              buttonText: 'Add Shop',
              onPressed: () {
                Navigator.pushNamed(context, '/shop-details');
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              buttonText: 'Your Existing Shop',
              onPressed: () {
                Navigator.pushNamed(context, '/existing-shop');
              },
            ),
            SizedBox(height: 40),
            Text('Service Registrations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CustomButton(
              buttonText: 'Add Service',
              onPressed: () {
                Navigator.pushNamed(context, '/add-service');
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              buttonText: 'Update your Service',
              onPressed: () {
                // Action to update service
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        selectedItemColor: Colors.green,
        onTap: (index) {
          // Handle bottom navigation actions
        },
      ),
    );
  }
}
