import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = true;
  bool _autoRenewals = false;

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFFC71626);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildSectionHeader('General'),
            _buildSwitchTile(
              'Push Notifications',
              _notifications,
              (val) => setState(() => _notifications = val),
              brandColor,
            ),
            _buildSwitchTile(
              'Dark Mode',
              _darkMode,
              (val) => setState(() => _darkMode = val),
              brandColor,
            ),

            const SizedBox(height: 32),

            _buildSectionHeader('Subscription Alerts'),
            _buildSwitchTile(
              'Auto-Renewal Alerts',
              _autoRenewals,
              (val) => setState(() => _autoRenewals = val),
              brandColor,
            ),
            _buildActionTile('Alert Threshold', '3 Days Before'),

            const SizedBox(height: 32),

            _buildSectionHeader('About'),
            _buildActionTile('Version', '1.0.0'),
            _buildActionTile('Terms of Service', ''),
            _buildActionTile('Privacy Policy', ''),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.grey[500],
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    bool value,
    Function(bool) onChanged,
    Color brandColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: brandColor,
            activeTrackColor: brandColor.withValues(alpha: 0.4),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 14),
            )
          else
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
        ],
      ),
    );
  }
}
