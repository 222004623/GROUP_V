/*
student number:
Student names: 
*/
import 'package:group_v/routeManager/RouteManager.dart';
import 'package:group_v/viewmodels/Student_viewmodel.dart';
import 'package:group_v/viewmodels/AuthViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xfjthrymxwxjbnlwrrtt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhmanRocnlteHd4amJubHdycnR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg1NDc5NDMsImV4cCI6MjA5NDEyMzk0M30.bySvP2Kga_LjkNZLuieB9AX_4mpDXuQcQ1A37zytyKE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => StudentViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: RouteManager.login, // Start on login screen
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
