import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isFirebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    isFirebaseInitialized = true;
  } catch (e) {
    print("Firebase init failed: $e");
    // Continue running the app even if Firebase fails,
    // so we can show a helpful error message in the UI.
  }
  runApp(MyApp(isFirebaseInitialized: isFirebaseInitialized));
}

class MyApp extends StatelessWidget {
  final bool isFirebaseInitialized;
  const MyApp({super.key, required this.isFirebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SubTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE21221)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: isFirebaseInitialized
          ? const AuthWrapper()
          : const ConfigurationErrorScreen(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          }
          return const HomeScreen();
        }
        return const Scaffold(
          backgroundColor: Color(0xFF0D0D0D),
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFFC71626)),
          ),
        );
      },
    );
  }
}

class ConfigurationErrorScreen extends StatelessWidget {
  const ConfigurationErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Firebase Setup Required',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'To run this app, you must configure your Firebase credentials.',
              style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step 1:',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFC71626),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Open lib/firebase_options.dart',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Step 2:',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFC71626),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Replace the TODO values with your actual Firebase API keys.',
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
