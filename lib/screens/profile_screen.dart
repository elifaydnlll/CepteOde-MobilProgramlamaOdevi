import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFFC71626);
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Guest';
    final initial = email.isNotEmpty ? email[0].toUpperCase() : 'G';
    final name = email.split('@')[0]; // Simple display name derivation

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: brandColor,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: brandColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name, // Displaying derived name
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email, // Displaying actual email
                style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
              ),

              const SizedBox(height: 40),

              // Menu Items
              _buildProfileItem(context, Icons.person_outline, 'Edit Profile'),
              _buildProfileItem(context, Icons.credit_card, 'Payment Methods'),
              _buildProfileItem(context, Icons.history, 'Billing History'),
              _buildProfileItem(context, Icons.security, 'Security'),

              const SizedBox(height: 40),

              // Sign Out
              TextButton(
                onPressed: () async {
                  await AuthService().signOut();
                  // No need to manually navigate if using StreamBuilder in main.dart,
                  // but to be safe and clear navigation stack:
                  if (context.mounted) {
                    // Since main.dart is wrapper, just popping potentially or it auto-updates.
                    // But usually it's safe to let the stream handle validation.
                    // If we are in a nested nav, we might need to pop all.
                  }
                },
                child: Text(
                  'Sign Out',
                  style: GoogleFonts.inter(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Security' || title == 'Edit Profile') {
          // Quick hack to link settings
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF161618),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[400], size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }
}
