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
   AuthenticationScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      backgroundColor: Colors.white,
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome Please Login"),
            SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name cant be empty";
                }
                return null;
              },
            ),

            SizedBox(height: 5),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                hintText: "Enter Password",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length != 15) {
                  return 'Password must be 15 digits';
                }
                if (!RegExp(r'^\d+ ').hasMatch(value)) {
                  return 'Only numbers allowed';
                }
                return null;
              },
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
      ),
    );
  }
}