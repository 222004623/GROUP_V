/*
student number:
Student names: 
*/
import 'package:flutter/material.dart';
import 'package:group_v/routeManager/RouteManager.dart';

// The system must provide a single authentication mechanism for all users. Authentication must verify user identity and restrict access to system functionality based on user role.
// Requirements
// o Users must provide valid login credentials.
// o Access to the system must be blocked until authentication succeeds.
// o After authentication, the system must direct users to an appropriate interface based on their role.
// Authentication must be implemented using Supabase Authentication.

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Column(
        children: [
          Text(
            "View submitted Student Assistant applications. View the current status of each application.",
          ),
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
