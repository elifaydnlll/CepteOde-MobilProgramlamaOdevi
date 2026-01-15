import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Premium Brand Color - Deep Burgundy/Crimson
    // Refined based on Figma inspection (#5C161C was the base, brightened slightly for UI pop)
    const brandColor = Color(0xFFC71626);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Container(
        // Radial Gradient Background (Spotlight effect)
        decoration: const BoxDecoration(
          color: Color(0xFF0D0D0D),
          gradient: RadialGradient(
            center: Alignment(0, -0.3), // Near the logo
            radius: 1.3,
            colors: [
              Color(0xFF1E1E1E), // Lighter center (spotlight)
              Color(0xFF0D0D0D), // Dark edges
            ],
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
                const SizedBox(height: 50),
                // Logo Area - Centered with Soft Glassy Box
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo Icon - Solid Rounded Square (No inner icon)
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: brandColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: brandColor.withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          // No child icon, just solid shape as per design inspection
                        ),
                        const SizedBox(height: 16),
                        // Logo Text: Sub (White) Track (Red)
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Sub',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Track',
                                style: TextStyle(color: brandColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // "Sign In" Title
                Center(
                  child: Text(
                    'Sign In',
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
                    'Login to your account',
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

                const SizedBox(height: 24),

                // Password Field
                _buildLabel('Password'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  activeColor: brandColor,
                ),

                const SizedBox(height: 16),

                // Forgot Password Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember me
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _rememberMe
                                  ? brandColor
                                  : Colors.transparent,
                              border: Border.all(
                                color: _rememberMe
                                    ? brandColor
                                    : Colors.grey[600]!,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: _rememberMe
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Remember me',
                            style: GoogleFonts.inter(
                              color: Colors.grey[400],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Forgot Password Link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.inter(
                          color: brandColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Sign In Button (Pill Shaped)
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
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) return;
                      // Show loading or something, or just await
                      try {
                        // We rely on Main stream to handle navigation, but since we are pushing replacement here,
                        // we might just wait for success.
                        // Actually, main.dart has a StreamBuilder. If we sign in, it should update.
                        // BUT, LoginScreen is currently 'home' in main.dart OR pushed.
                        // If main.dart uses StreamBuilder, the user will be sent to HomeScreen automatically.

                        await AuthService().signIn(email, password);
                        // No need to navigate manually if main.dart handles it,
                        // but if this screen was pushed over main, we might need to pop?
                        // In main.dart I set StreamBuilder as home.
                        // So if I am here, it means I am not logged in.
                        // Once I log in, the StreamBuilder will switch to HomeScreen.
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                              style: GoogleFonts.inter(color: Colors.white),
                            ),
                            backgroundColor: Colors.red[900],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign Up Link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: "Sign Up",
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
      padding: const EdgeInsets.only(
        left: 12.0,
      ), // Aligned with pill shape curve
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
    bool isPassword = false,
    required Color activeColor,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: const TextStyle(color: Colors.white),
      cursorColor: activeColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF161618), // Slightly darker/richer fill
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
        suffixIcon: isPassword
            ? Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white70, // White icon as requested
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Pill Shape
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
