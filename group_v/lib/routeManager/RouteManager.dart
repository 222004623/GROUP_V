/*
student number:
Student names: 
*/
import 'package:flutter/material.dart';
import 'package:group_v/models/Students.dart';
import 'package:group_v/views/Authentication_Screen.dart';
import 'package:group_v/views/Application_Detail_Screen.dart';
import 'package:group_v/views/Home_Screen.dart';
import 'package:group_v/views/Admin_Dashboard.dart';
import 'package:group_v/views/edit_student_page.dart';
import 'package:group_v/views/confirm_view.dart';
import 'package:group_v/views/StudentAssistantApplicationForm.dart';

class RouteManager {
  static const String login = '/login';
  static const String home = '/home';
  static const String edit = '/edit';
  static const String confirm = '/confirm';
  static const String details = '/details';
  static const String applicationForm = '/applicationForm';
  static const String adminDashboard = '/adminDashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const AuthenticationScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeView());

      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashBoardView());

      case details:
        // Student is passed as argument from AdminDashboard
        final student = settings.arguments as Student?;
       
        return MaterialPageRoute(
          builder: (_) => StudentDetailsPage(student: student, message: ''),
        );

      case edit:
        // Student is passed as argument so EditStudentPage can pre-fill fields
        final student = settings.arguments as Student?;
        return MaterialPageRoute(
          builder: (_) => EditStudentPage(student: student),
        );

      case confirm:
        return MaterialPageRoute(builder: (_) => const ConfirmView());

      case applicationForm:
        return MaterialPageRoute(builder: (_) => const StudentAssistantApp());

      default:
        return MaterialPageRoute(builder: (_) => const AuthenticationScreen());
    }
  }
}
