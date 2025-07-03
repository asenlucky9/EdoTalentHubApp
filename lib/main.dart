import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/app_config.dart';
import 'config/app_theme.dart';
import 'config/firebase_options.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/booking/domain/models/booking.dart';
import 'shared/providers/user_provider.dart';
import 'shared/services/firebase_service.dart';
import 'features/welcome/presentation/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(BookingAdapter());
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Firebase services
  await FirebaseService.initialize();
  
  runApp(const ProviderScope(child: EdoTalentHubApp()));
}

class EdoTalentHubApp extends ConsumerWidget {
  const EdoTalentHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authUserProvider);
          
          return authState.when(
            data: (user) {
              if (user == null) {
                return const WelcomeScreen();
              }
              return const DashboardScreen();
            },
            loading: () => const SplashScreen(),
            error: (error, stack) => const WelcomeScreen(),
          );
        },
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
