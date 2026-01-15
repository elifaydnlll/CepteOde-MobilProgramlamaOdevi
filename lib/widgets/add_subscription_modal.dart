import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/subscription.dart';
import '../services/database_service.dart';

class AddSubscriptionModal extends StatefulWidget {
  final Subscription? subscriptionToEdit;

  const AddSubscriptionModal({super.key, this.subscriptionToEdit});

  @override
  State<AddSubscriptionModal> createState() => _AddSubscriptionModalState();
}

class _AddSubscriptionModalState extends State<AddSubscriptionModal> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = 'Video';
  Color _selectedColor = const Color(0xFFE50914);
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));

  final Map<String, Color> _categoryColors = {
    'Video': const Color(0xFFE50914),
    'Music': const Color(0xFF1DB954),
    'Gaming': const Color(0xFF00439C),
    'Utility': const Color(0xFFFFA000),
    'Social': const Color(0xFF5865F2),
  };

  final Map<String, IconData> _categoryIcons = {
    'Video': Icons.play_circle_fill,
    'Music': Icons.music_note,
    'Gaming': Icons.gamepad,
    'Utility': Icons.build,
    'Social': Icons.people,
  };

  @override
  void initState() {
    super.initState();
    if (widget.subscriptionToEdit != null) {
      final sub = widget.subscriptionToEdit!;
      _nameController.text = sub.name;
      _priceController.text = sub.price.toString();
      _category = sub.category;
      _selectedColor = sub
          .color; // Usually color follows category, but we keep this for consistency
      _selectedDate = sub.nextRenewalDate;
      // Ensure the category color is correct if the category overrides it,
      // but if we allowed custom colors before, we keep it.
      // For now, we trust the mapped color or the specific one.
      if (_categoryColors.containsKey(_category)) {
        _selectedColor = _categoryColors[_category]!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFFC71626);
    final isEditing = widget.subscriptionToEdit != null;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF161618),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: brandColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isEditing ? Icons.edit : Icons.add,
                  color: brandColor,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                isEditing ? 'Edit Subscription' : 'New Subscription',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Name Input
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              labelText: 'Subscription Name',
              labelStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: const Icon(
                Icons.description_outlined,
                color: Colors.grey,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: brandColor),
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 20),

          // Price Input
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              labelText: 'Monthly Price',
              labelStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: brandColor),
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 20),

          // Date Picker
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: brandColor,
                        onPrimary: Colors.white,
                        surface: Color(0xFF161618),
                        onSurface: Colors.white,
                      ),
                      dialogTheme: const DialogThemeData(
                        backgroundColor: Color(0xFF0D0D0D),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First Payment Date',
                        style: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM d, yyyy').format(_selectedDate),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Category',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Visual Category Selector
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categoryColors.keys.map((cat) {
                final isSelected = _category == cat;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _category = cat;
                      _selectedColor = _categoryColors[cat]!;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    width: isSelected ? 80 : 70,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _categoryColors[cat]
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 2)
                          : Border.all(color: Colors.transparent),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _categoryIcons[cat],
                          color: isSelected ? Colors.white : Colors.grey,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat,
                          style: GoogleFonts.inter(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final price = double.tryParse(_priceController.text) ?? 0.0;

                if (name.isNotEmpty && price > 0) {
                  try {
                    if (isEditing) {
                      // Update existing
                      final updatedSub = Subscription(
                        id: widget.subscriptionToEdit!.id,
                        name: name,
                        category: _category,
                        price: price,
                        nextRenewalDate: _selectedDate,
                        color: _selectedColor,
                      );
                      await DatabaseService().updateSubscription(updatedSub);
                    } else {
                      // Add new
                      final newSub = Subscription(
                        id: '', // ID will be auto-generated or ignored by add method
                        name: name,
                        category: _category,
                        price: price,
                        nextRenewalDate: _selectedDate,
                        color: _selectedColor,
                      );
                      print("Adding new subscription: ${newSub.name}");
                      await DatabaseService().addSubscription(newSub);
                      print("Subscription added successfully.");
                    }

                    if (mounted) {
                      Navigator.pop(context, true); // Return success
                    }
                  } catch (e) {
                    print("Error saving subscription: $e");
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to save subscription: $e'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid name and price.'),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: brandColor.withValues(alpha: 0.5),
              ),
              child: Text(
                isEditing ? 'Update Subscription' : 'Save Subscription',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
