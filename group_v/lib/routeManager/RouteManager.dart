import 'package:flutter/material.dart';
import 'package:group_v/models/Students.dart';
import 'package:group_v/views/Admin_Dashboard.dart';
import 'package:group_v/views/Application_Detail_Screen.dart';
import 'package:group_v/views/Home_Screen.dart';
import 'package:group_v/views/StudentAssistantApplicationForm.dart';

class RouteManager {
  //Static routes
  static const String login = '/login';
  static const String home = '/';
  static const String details = '/details';
  static const String applicationForm = '/applicationForm';
  static const String adminDashboard = '/adminDashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const HomeView());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeView());

      case details:
        final message = settings.arguments as String; // dynamic route
        return MaterialPageRoute(
          builder: (_) => StudentDetailsPage(message: message),
        );

      case applicationForm:
        return MaterialPageRoute(builder: (_) => const EditStudentPage());

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const ConfirmView());

      default:
        throw Exception("Route not found");
    }
  }
}
