import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFFC71626);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D0D0D),
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.3,
            colors: [Color(0xFF1E1E1E), Color(0xFF0D0D0D)],
            stops: [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 20),

                // "Forgot Password" Title
                Center(
                  child: Text(
                    'Forgot Password',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Enter your email to reset password',
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                _buildLabel('Email'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hint: 'example@email.com',
                  icon: Icons.email_outlined,
                  activeColor: brandColor,
                ),

                const SizedBox(height: 40),

                // Send Button
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: brandColor.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Send Reset Logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Reset link sent to your email',
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                          backgroundColor: Colors.green[800],
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Send Reset Link',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Back to Login Link
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: "Back to "),
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              color: brandColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.grey[400],
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required Color activeColor,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: activeColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF161618),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 12.0),
          child: Icon(icon, color: Colors.grey[600], size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 50),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: activeColor, width: 1),
        ),
      ),
    );
  }
}
