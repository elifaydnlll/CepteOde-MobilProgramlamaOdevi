import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/fade_in_slide.dart';
import '../services/database_service.dart';
import '../models/subscription.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Subscription>>(
      stream: DatabaseService().subscriptions,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Error loading data")),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0D0D0D),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final subscriptions = snapshot.data ?? [];

        // --- Calculations ---
        double totalCost = subscriptions.fold(
          0,
          (sum, item) => sum + item.price,
        );
        int subCount = subscriptions.length;
        double avgCost = subCount > 0 ? totalCost / subCount : 0.0;
        double budget = 200.0; // Fixed budget for now
        double budgetProgress = (totalCost / budget).clamp(0.0, 1.0);

        // Group by Category for Bar Chart
        Map<String, double> categoryMap = {};
        for (var sub in subscriptions) {
          categoryMap[sub.category] =
              (categoryMap[sub.category] ?? 0) + sub.price;
        }
        // Convert to list for chart
        List<MapEntry<String, double>> sortedCategories =
            categoryMap.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value)); // Sort by cost desc

        // Take top 5 for chart
        final chartData = sortedCategories.take(5).toList();

        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: Stack(
            children: [
              // Ambient Background Lights
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.withValues(alpha: 0.15),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      FadeInSlide(
                        delay: 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => Navigator.pop(context),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.05,
                                ),
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                            Text(
                              'Analytics',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                shape: BoxShape.circle,
                                // Use a generic icon or initials if no image
                                // image: const DecorationImage(image: NetworkImage('...')),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Hero Card - Spending Limit
                      FadeInSlide(
                        delay: 0.2,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF6366F1,
                                ).withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monthly Limit',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${totalCost.toStringAsFixed(0)} / \$${budget.toStringAsFixed(0)}',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${(budgetProgress * 100).toStringAsFixed(0)}%',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: budgetProgress,
                                  backgroundColor: Colors.black.withValues(
                                    alpha: 0.2,
                                  ),
                                  color: Colors.white,
                                  minHeight: 8,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                totalCost > budget
                                    ? 'You have exceeded your budget!'
                                    : 'Excellent! You represent a healthy budget.',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Visual Spend Chart (Calculated from Data)
                      FadeInSlide(
                        delay: 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Top Categories',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeInSlide(
                        delay: 0.4,
                        child: SizedBox(
                          height: 220,
                          child: chartData.isEmpty
                              ? Center(
                                  child: Text(
                                    "No data to display",
                                    style: GoogleFonts.inter(
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : BarChart(
                                  BarChartData(
                                    barTouchData: BarTouchData(
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipPadding: const EdgeInsets.all(8),
                                        tooltipMargin: 8,
                                        getTooltipItem:
                                            (group, groupIndex, rod, rodIndex) {
                                              return BarTooltipItem(
                                                rod.toY.round().toString(),
                                                const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                    gridData: FlGridData(show: false),
                                    borderData: FlBorderData(show: false),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget:
                                              (double value, TitleMeta meta) {
                                                if (value.toInt() >= 0 &&
                                                    value.toInt() <
                                                        chartData.length) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 8.0,
                                                        ),
                                                    child: Text(
                                                      chartData[value.toInt()]
                                                          .key
                                                          .substring(0, 3)
                                                          .toUpperCase(), // First 3 chars
                                                      style: GoogleFonts.inter(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                              },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                    ),
                                    barGroups: List.generate(chartData.length, (
                                      index,
                                    ) {
                                      return _buildBarGroup(
                                        index,
                                        chartData[index].value,
                                        Colors.primaries[index %
                                                Colors.primaries.length +
                                            5], // Varying colors
                                      );
                                    }),
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Quick Stats Row
                      FadeInSlide(
                        delay: 0.5,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildDashboardCard(
                                'Subscriptions',
                                '$subCount',
                                Icons.card_membership,
                                const Color(0xFFFACC15),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDashboardCard(
                                'Avg. Cost',
                                '\$${avgCost.toStringAsFixed(1)}',
                                Icons.analytics_outlined,
                                const Color(0xFF22D3EE),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 18,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: y * 1.2 + 20, // Dynamic max height based on data
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
