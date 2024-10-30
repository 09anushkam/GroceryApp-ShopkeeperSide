import 'package:flutter/material.dart';
import 'add_service.dart'; // Import the service model

class AddNewServiceScreen extends StatefulWidget {
  @override
  _AddNewServiceScreenState createState() => _AddNewServiceScreenState();
}

class _AddNewServiceScreenState extends State<AddNewServiceScreen> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _locationController = TextEditingController();

  // Confirm addition of new service if all fields are filled
  void _confirmAddition(BuildContext context) {
    if (_nameController.text.isNotEmpty &&
        _numberController.text.isNotEmpty &&
        _locationController.text.isNotEmpty) {
      final newService = Service(
        name: _nameController.text,
        number: _numberController.text,
        location: _locationController.text,
      );

      Navigator.pop(
          context, newService); // Return the new service to AddServiceScreen
    } else {
      // Show a message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Service'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Service Name'),
            ),
            TextField(
              controller: _numberController,
              decoration: InputDecoration(labelText: 'Contact Number'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _confirmAddition(context),
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
