import 'package:flutter/material.dart';
import 'add_new_service.dart'; // Import the screen to add new services

class AddServiceScreen extends StatefulWidget {
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  // Initial list of services
  List<Service> services = [
    Service(name: 'Plumbing', number: '9082689547', location: 'Worli West'),
    Service(name: 'Electrician', number: '9876543210', location: 'Worli East'),
    Service(name: 'Cleaning', number: '7551234567', location: 'Koliwada Worli'),
    Service(name: 'Laundry', number: '9449876543', location: 'Prabhadevi'),
  ];

  // Adds a new service to the list and updates the state
  void _addService(Service newService) {
    setState(() {
      services.add(newService);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Services'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(service.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Number: ${service.number}'),
                  Text('Location: ${service.location}'),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            // Navigate to AddNewServiceScreen and wait for a result
            final newService = await Navigator.push<Service>(
              context,
              MaterialPageRoute(
                builder: (context) => AddNewServiceScreen(),
              ),
            );

            // If newService is not null, add it to the list
            if (newService != null) {
              _addService(newService);
            }
          },
          child: Text(
            'Add Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}

// Service model class
class Service {
  final String name;
  final String number;
  final String location;

  Service({required this.name, required this.number, required this.location});
}
