import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/dolibarr_provider.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DolibarrApp());
}

class DolibarrApp extends StatelessWidget {
  const DolibarrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DolibarrProvider>(
          create: (_) => DolibarrProvider(),
          update: (_, auth, dolibarr) {
            dolibarr?.updateConfig(auth.config);
            return dolibarr ?? DolibarrProvider();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Dolibarr Mobile Enterprise',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const DashboardScreen(),
      ),
    );
  }
}
