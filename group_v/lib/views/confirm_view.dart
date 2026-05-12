// TODO Implement this library.
/*
student number:
Student names: 
*/
import 'package:flutter/material.dart';
import 'package:group_v/routeManager/RouteManager.dart';

// Display submitted Student Assistant application 
// View current status of a student application.
class ConfirmView extends StatelessWidget {
  const ConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Column(
        children: [
          Text("View submitted Student Assistant applications. View the current status of each application."),
          SizedBox(height: 10), 
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteManager.details,
                  arguments: "Hello from Home", // dynamic data
                );
              },
              child: const Text("Go to Details (Dynamic Route)"),
            ),
          ),
        ],
      ),
    );
  }
}