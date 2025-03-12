import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/auth/login_page.dart';
import 'views/dashboard_page.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.checkLoginStatus(); // Cek apakah user sudah login

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Poppins'),
          home: authProvider.isLoggedIn ? DashboardPage() : LoginPage(),
        );
      },
    );
  }
}
