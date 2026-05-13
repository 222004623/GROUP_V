/* 
Student Number:  222004623, 224051673, 223019042, 220044858, 223002326, 221032720     
Student Names:  Seatlholo KG, Matsane K, Molefe SB, Nyelimane T, Lesenyeho LJ, NF Zwane

Question: Main.Dart file
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_theme.dart';
import 'viewmodels/admin_viewmodel.dart';
import 'viewmodels/application_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/notification_viewmodel.dart';
import 'views/admin/admin_shell_view.dart';
import 'views/auth/auth_gate_view.dart';
import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';
import 'views/auth/splash_view.dart';
import 'views/student/complete_profile_view.dart';
import 'views/student/student_shell_view.dart';
import 'widgets/global_loading_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://clzyxvumvwtlsjxwlhoa.supabase.co',
    anonKey: 'sb_publishable_Azo0Tynk0_UwbP75ETqgBQ_CcYIKVZQ',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ApplicationViewModel()),
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final hasSession = Supabase.instance.client.auth.currentUser != null;

    return MaterialApp(
      title: 'Student Assistant Applications',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      builder: (context, child) {
        return GlobalLoadingOverlay(child: child ?? const SizedBox.shrink());
      },
      initialRoute: hasSession ? '/session' : '/',
      routes: {
        '/': (_) => const SplashView(),
        '/session': (_) => const AuthGateView(),
        '/login': (_) => const LoginView(),
        '/register': (_) => const RegisterView(),
        '/complete-profile': (_) => const CompleteProfileView(),
        '/student': (_) => const StudentShellView(),
        '/admin': (_) => const AdminShellView(),
      },
    );
  }
}
