import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/habit.dart';

class CreateHabitPage extends StatefulWidget {
  final Habit? habit;

  const CreateHabitPage({super.key, this.habit});

  @override
  State<CreateHabitPage> createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isReminderEnabled = true;
  String _selectedFrequency = 'Daily';
  DateTime _startDate = DateTime.now();
  final List<String> _frequencies = ['Daily', 'Weekly', 'Monthly'];
  @override
  void initState() {
    super.initState();

    if (widget.habit != null) {
      _nameController.text = widget.habit!.title;
      _descController.text = widget.habit!.description;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedFrequency = widget.habit!.frequency;
          _startDate = widget.habit!.startDate;
          _isReminderEnabled = widget.habit!.reminderEnabled;
        });
      });
    }
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF8F9FE),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 60,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppTheme.primaryColor),
        onPressed: () => context.pop(),
      ),
      title: Text(
        widget.habit == null ? 'Create Habit' : 'Edit Habit',
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("HABIT NAME"),
          _buildTextField(_nameController, "e.g., Morning Meditation"),
          const SizedBox(height: 24),
          
          _buildLabel("SHORT DESCRIPTION"),
          _buildTextField(_descController, "Why is this habit important to you?", maxLines: 4),
          const SizedBox(height: 24),

          Row(
            children: [
              // Start Date Picker
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("START DATE"),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _startDate = picked);
                      },
                      child: _buildSelectorContainer(
                        "${_startDate.month}/${_startDate.day}/${_startDate.year}",
                        Icons.calendar_today_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Frequency Dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("FREQUENCY"),
                    _buildFrequencyDropdown(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Daily Reminder Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_none, color: Colors.black54),
                const SizedBox(width: 12),
                const Text("Daily Reminder", style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                    Transform.scale(
                      scale: 0.95,
                      child: Switch(
                        value: _isReminderEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isReminderEnabled = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: AppTheme.primaryColor,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: AppTheme.primaryColor.withOpacity(0.4),
              ),
              onPressed: () {
                final titleText = _nameController.text.trim();

                if (titleText.isNotEmpty){

                if (widget.habit == null) {
                  // CREATE
                  context.read<HabitBloc>().add(
                    AddHabit(
                      title: titleText,
                      description: _descController.text,
                      frequency: _selectedFrequency,
                      startDate: _startDate,
                      reminderEnabled: _isReminderEnabled,
                    ),
                  );
                } else {
                  // UPDATE
                  final updated = widget.habit!.copyWith(
                    title: titleText,
                    description: _descController.text,
                    frequency: _selectedFrequency,
                    startDate: _startDate,
                    reminderEnabled: _isReminderEnabled,
                  );

                  context.read<HabitBloc>().add(UpdateHabit(updated));
                }

                context.pop();
              } else {
                  // 2. The title is empty! Show a friendly warning banner
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.white),
                          SizedBox(width: 12),
                          Text(
                            "Please fill in the habit name!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating, // Makes it float above the bottom navigation
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 2), // Hide automatically after 2 seconds
                    ),
                  );
                }
              },
              
              child: Text(
                widget.habit == null ? "Save Habit" : "Update Habit",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
        ],
      ),
    ),
  );
}

// --- HELPER WIDGETS ---

Widget _buildFrequencyDropdown() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedFrequency,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        items: _frequencies.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
        onChanged: (val) => setState(() => _selectedFrequency = val!),
      ),
    ),
  );
}

Widget _buildSelectorContainer(String text, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(color: Colors.black87)),
        Icon(icon, size: 20, color: Colors.black54),
      ],
    ),
  );
}

  // --- Helper UI Widgets ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 1.1)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }

  
}