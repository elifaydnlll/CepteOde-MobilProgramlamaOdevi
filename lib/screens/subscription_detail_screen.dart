import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../widgets/add_subscription_modal.dart';
import 'payment_screen.dart';
import '../services/database_service.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  final Subscription subscription;

  const SubscriptionDetailScreen({super.key, required this.subscription});

  @override
  State<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  late Subscription _currentSubscription;

  @override
  void initState() {
    super.initState();
    _currentSubscription = widget.subscription;
  }

  void _handleEdit() async {
    bool? result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          AddSubscriptionModal(subscriptionToEdit: _currentSubscription),
    );

    if (result == true) {
      // Since we updated in Firebase, getting the latest data might require fetching it again.
      // But since we are inside a value passed from a list from a Stream,
      // the parent (Dashboard) will rebuild with new data.
      // However, to update THIS screen's state immediately (e.g. name changed),
      // we might want to refetch or assume the modal passed back the new object?
      // The modal currently returns true/false.
      // The simplest way to "refresh" this detail view is often just popping back,
      // or we can listen to the document stream.
      // For now, let's just pop back to dashboard to see changes there.
      Navigator.pop(context, true);
    }
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161618),
        title: Text(
          'Delete Subscription?',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove this subscription?',
          style: GoogleFonts.inter(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: Text(
              'Delete',
              style: GoogleFonts.inter(color: Colors.redAccent),
            ),
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              try {
                await DatabaseService().deleteSubscription(
                  _currentSubscription.id,
                );
                if (mounted) {
                  Navigator.pop(context, true);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _handleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Big Icon Header
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _currentSubscription.color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _currentSubscription.color.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _currentSubscription.color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getCategoryIcon(_currentSubscription.category),
                    size: 50,
                    color: _currentSubscription.color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _currentSubscription.name,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _currentSubscription.category,
                style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 14),
              ),
            ),

            const SizedBox(height: 40),

            // Stats Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'Price',
                      '\$${_currentSubscription.price}',
                      Icons.attach_money,
                      Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard(
                      'Cycle',
                      'Monthly', // Mock data, usually in model
                      Icons.loop,
                      Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildInfoCard(
                'Next Billing Date',
                DateFormat(
                  'MMMM d, y',
                ).format(_currentSubscription.nextRenewalDate),
                Icons.calendar_today,
                Colors.orangeAccent,
                fullWidth: true,
              ),
            ),

            const SizedBox(height: 40),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentScreen(subscription: _currentSubscription),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC71626),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Pay Now / Extend',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Video':
        return Icons.play_circle_fill;
      case 'Music':
        return Icons.music_note;
      case 'Gaming':
        return Icons.gamepad;
      case 'Utility':
        return Icons.build;
      case 'Social':
        return Icons.people;
      default:
        return Icons.category;
    }
  }
}
