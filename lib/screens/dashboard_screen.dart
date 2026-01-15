import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'payment_screen.dart';
import 'reports_screen.dart';
import 'support_screen.dart';
import 'subscription_list_screen.dart'; // To access class if needed, but we use tab switching mostly or direct nav
import '../services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subscription.dart';
import '../widgets/fade_in_slide.dart';

import '../widgets/add_subscription_modal.dart';
import 'subscription_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final double budgetLimit = 200.0; // Mock Budget Limit
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // We can use a default name or fetch from auth.
    // For now, let's just use "User" or email part if display name is null.
    final String userName =
        user?.displayName ?? (user?.email?.split('@')[0] ?? 'User');

    return StreamBuilder<List<Subscription>>(
      stream: DatabaseService().subscriptions,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF0D0D0D),
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
          );
        }

        // Show loading only if we have no data yet?
        // Or show empty state?
        // Let's show loading initially.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0D0D0D),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFC71626)),
            ),
          );
        }

        final subscriptions = snapshot.data ?? [];

        // Calculate Summary Data
        double totalMonthlyCost = subscriptions.fold(
          0,
          (sum, item) => sum + item.price,
        );
        int activeSubs = subscriptions.length;

        // Find Top Spender
        Subscription? topSpender;
        if (subscriptions.isNotEmpty) {
          topSpender = subscriptions.reduce(
            (curr, next) => curr.price > next.price ? curr : next,
          );
        }

        // Group by category for Pie Chart
        Map<String, double> categoryCosts = {};
        for (var sub in subscriptions) {
          categoryCosts[sub.category] =
              (categoryCosts[sub.category] ?? 0) + sub.price;
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  FadeInSlide(
                    delay: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: GoogleFonts.inter(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Elif',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions
                  FadeInSlide(
                    delay: 0.1,
                    child: SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildQuickAction(
                            context,
                            'Add New',
                            Icons.add_circle_outline,
                            () async {
                              bool? result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors
                                    .transparent, // Transparent so our container handles radius
                                builder: (ctx) => const AddSubscriptionModal(),
                              );
                              if (result == true) {
                                setState(
                                  () {},
                                ); // Refresh dashboard to show new sub/stats
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Subscription added successfully!',
                                    ),
                                    backgroundColor: Color(0xFF43A047),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildQuickAction(
                            context,
                            'Reports',
                            Icons.bar_chart,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReportsScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildQuickAction(
                            context,
                            'Support',
                            Icons.headset_mic,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SupportScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Summary Cards
                  FadeInSlide(
                    delay: 0.2,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Monthly Spend',
                            value: '\$${totalMonthlyCost.toStringAsFixed(2)}',
                            icon: Icons.attach_money,
                            color: const Color(0xFFC71626),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSummaryCard(
                            title: 'Active Subs',
                            value: '$activeSubs',
                            icon: Icons.apps,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Budget & Top Spender Section
                  FadeInSlide(
                    delay: 0.3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Budget Progress
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monthly Budget',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF161618),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.05),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${totalMonthlyCost.toStringAsFixed(0)} / \$$budgetLimit',
                                          style: GoogleFonts.inter(
                                            color: Colors.grey[400],
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          '${(totalMonthlyCost / budgetLimit * 100).toStringAsFixed(0)}%',
                                          style: GoogleFonts.inter(
                                            color:
                                                totalMonthlyCost > budgetLimit
                                                ? Colors.red
                                                : Colors.greenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: (totalMonthlyCost / budgetLimit)
                                            .clamp(0.0, 1.0),
                                        backgroundColor: Colors.white
                                            .withValues(alpha: 0.1),
                                        color: totalMonthlyCost > budgetLimit
                                            ? const Color(0xFFDC143C)
                                            : const Color(
                                                0xFFC71626,
                                              ), // Crimson
                                        minHeight: 8,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      totalMonthlyCost > budgetLimit
                                          ? 'Over Budget!'
                                          : 'You are on track.',
                                      style: GoogleFonts.inter(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Top Spender Mini Card
                        if (topSpender != null)
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Top Spender',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF161618),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: topSpender.color.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            topSpender.name[0],
                                            style: TextStyle(
                                              color: topSpender.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        topSpender.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        '\$${topSpender.price}',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Modern Analytics Section
                  FadeInSlide(
                    delay: 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spending Analysis',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161618),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Left: Donut Chart with Gaps & Rounded Caps
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: 160,
                                  child: Stack(
                                    children: [
                                      PieChart(
                                        PieChartData(
                                          pieTouchData: PieTouchData(
                                            touchCallback:
                                                (
                                                  FlTouchEvent event,
                                                  pieTouchResponse,
                                                ) {
                                                  setState(() {
                                                    if (!event
                                                            .isInterestedForInteractions ||
                                                        pieTouchResponse ==
                                                            null ||
                                                        pieTouchResponse
                                                                .touchedSection ==
                                                            null) {
                                                      _touchedIndex = -1;
                                                      return;
                                                    }
                                                    _touchedIndex =
                                                        pieTouchResponse
                                                            .touchedSection!
                                                            .touchedSectionIndex;
                                                  });
                                                },
                                          ),
                                          borderData: FlBorderData(show: false),
                                          sectionsSpace:
                                              8, // Added spacing like the reference image
                                          centerSpaceRadius: 40,
                                          sections: List.generate(
                                            categoryCosts.length,
                                            (i) {
                                              final isTouched =
                                                  i == _touchedIndex;
                                              final radius = isTouched
                                                  ? 35.0
                                                  : 30.0;
                                              final category = categoryCosts
                                                  .keys
                                                  .elementAt(i);
                                              final value = categoryCosts.values
                                                  .elementAt(i);
                                              final color = _getCategoryColor(
                                                category,
                                              );
                                              final percentage =
                                                  (value /
                                                          totalMonthlyCost *
                                                          100)
                                                      .round();

                                              return PieChartSectionData(
                                                color: color,
                                                value: value,
                                                title:
                                                    '$percentage%', // Show percentage inside
                                                titleStyle: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                radius: radius,
                                                badgeWidget:
                                                    null, // Removed external badge to keep it clean like reference
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _touchedIndex == -1
                                                  ? '\$${totalMonthlyCost.toStringAsFixed(0)}'
                                                  : '\$${categoryCosts.values.elementAt(_touchedIndex).toStringAsFixed(0)}',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              _touchedIndex == -1
                                                  ? 'Total'
                                                  : categoryCosts.keys
                                                        .elementAt(
                                                          _touchedIndex,
                                                        ),
                                              style: GoogleFonts.inter(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              // Right: Category Breakdown List
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: categoryCosts.entries.take(4).map((
                                    entry,
                                  ) {
                                    final color = _getCategoryColor(entry.key);
                                    final percentage =
                                        entry.value / totalMonthlyCost;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      color: color,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    entry.key,
                                                    style: GoogleFonts.inter(
                                                      color: Colors.grey[300],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '\$${entry.value.toStringAsFixed(0)}',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                            child: LinearProgressIndicator(
                                              value: percentage,
                                              backgroundColor: Colors.white
                                                  .withValues(alpha: 0.05),
                                              color: color,
                                              minHeight: 4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Upcoming Renewals
                  FadeInSlide(
                    delay: 0.5,
                    child: Text(
                      'Upcoming Renewals',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subscriptions.length,
                    itemBuilder: (context, index) {
                      final sub = subscriptions[index];
                      // Simple logic to show soonest first if we sorted, but we take list as is for now
                      return FadeInSlide(
                        delay: 0.6 + (index * 0.1),
                        child: GestureDetector(
                          onTap: () async {
                            // Navigate to Detail Screen
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SubscriptionDetailScreen(subscription: sub),
                              ),
                            );
                            setState(() {}); // Refresh dashboard on return
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161618),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: sub.color.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      sub.name[0],
                                      style: TextStyle(
                                        color: sub.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sub.name,
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        sub.category,
                                        style: GoogleFonts.inter(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${sub.price}',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          DateFormat(
                                            'MMM d',
                                          ).format(sub.nextRenewalDate),
                                          style: GoogleFonts.inter(
                                            color:
                                                _getDaysRemaining(
                                                      sub.nextRenewalDate,
                                                    ) <=
                                                    3
                                                ? Colors.redAccent
                                                : Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        if (_getDaysRemaining(
                                              sub.nextRenewalDate,
                                            ) <=
                                            5)
                                          const Icon(
                                            Icons.payment,
                                            size: 14,
                                            color: Colors.orange,
                                          )
                                        else
                                          const Icon(
                                            Icons.chevron_right,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF161618),
            Color(0xFF161618).withValues(alpha: 0.8), // subtle
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
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
            style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Video':
        return const Color(0xFFE50914);
      case 'Music':
        return const Color(0xFF1DB954);
      case 'Gaming':
        return const Color(0xFF00439C);
      case 'Utility':
        return const Color(0xFFFFA000); // Orange
      case 'Social':
        return const Color(0xFF5865F2);
      default:
        return Colors.grey;
    }
  }

  int _getDaysRemaining(DateTime date) {
    return date.difference(DateTime.now()).inDays;
  }
}
