import 'package:group_v/routeManager/RouteManager.dart';
import 'package:group_v/viewmodels/Student_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider (
      create: (_)=> StudentViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: RouteManager.home,
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}