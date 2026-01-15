import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/subscription.dart';

class PaymentScreen extends StatefulWidget {
  final Subscription subscription;

  const PaymentScreen({super.key, required this.subscription});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFFC71626);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isSuccess ? _buildSuccessView() : _buildPaymentForm(brandColor),
    );
  }

  Widget _buildPaymentForm(Color brandColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subscription Summary Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF161618),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.subscription.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      widget.subscription.name[0],
                      style: TextStyle(
                        color: widget.subscription.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment for',
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        widget.subscription.name,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${widget.subscription.price}',
                        style: GoogleFonts.inter(
                          color: brandColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Text(
            'Payment Method',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Realistic Card Visual
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1a1c20),
                  Color(0xFF2d3436),
                ], // Premium dark metallic look
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background decoration (subtle rings)
                Positioned(
                  right: -100,
                  top: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  left: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // EMV Chip Simulation
                          Container(
                            width: 50,
                            height: 35,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37), // Gold base
                              borderRadius: BorderRadius.circular(6),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD4AF37),
                                  Color(0xFFFEE190),
                                  Color(0xFFD4AF37),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 50,
                                    height: 1,
                                    color: Colors.black12,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 1,
                                    height: 35,
                                    color: Colors.black12,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Contactless Icon
                          const Icon(
                            Icons.wifi,
                            color: Colors.white70,
                            size: 28,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '4321  7890  1234  4242',
                        style: GoogleFonts.shareTechMono(
                          // Using a more technical/card-like font if available, or fallback
                          color: Colors.white,
                          fontSize: 24,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            const Shadow(
                              color: Colors.black45,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CARD HOLDER',
                                style: GoogleFonts.inter(
                                  color: Colors.white54,
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ELIF',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),

                          // Mastercard Logo Simulation
                          SizedBox(
                            width: 60,
                            height: 40,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withValues(
                                        alpha: 0.9,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Pay Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Confirm Payment',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF43A047), size: 100),
          const SizedBox(height: 24),
          Text(
            'Payment Successful!',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your subscription has been extended.',
            style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 16),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Update the subscription date in the mock list
                // Find instance in global list and update (Mock DB logic)
                int index = mockSubscriptions.indexWhere(
                  (s) => s.id == widget.subscription.id,
                );
                if (index != -1) {
                  mockSubscriptions[index].nextRenewalDate =
                      mockSubscriptions[index].nextRenewalDate.add(
                        const Duration(days: 30),
                      );
                }

                Navigator.pop(context, true); // Return true to indicate change
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Done',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _isSuccess = true;
    });
  }
}
