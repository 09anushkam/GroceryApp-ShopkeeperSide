import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For displaying success message
import 'registration_screen.dart'; // Import the registration screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle login
  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // If login is successful, show toast and navigate to the registration screen
      Fluttertoast.showToast(msg: 'Logged in successfully!');
      Navigator.pushNamed(context, '/registration'); // Navigate to RegistrationScreen
    } catch (e) {
      Fluttertoast.showToast(msg: 'Login failed. Please try again.');
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Login',
              textAlign: TextAlign.center, // Center align the text
              style: TextStyle(
                fontSize: 32, // Larger font size
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
            SizedBox(height: 20), // Bottom padding for spacing
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 40), // Increase space to move the button downwards
            ElevatedButton(
              onPressed: _login,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 18), // White text inside the button
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Green button color
                padding: EdgeInsets.symmetric(vertical: 16), // Vertical padding for button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50), // Make button wide
              ),
            ),
          ],
        ),
      ),
    );
  }
}
