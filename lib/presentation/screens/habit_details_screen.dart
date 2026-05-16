import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/habit.dart';
import 'package:go_router/go_router.dart';
import '../widgets/delete_habit_dialog.dart';
import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_event.dart';


class HabitDetailsPage extends StatelessWidget {
  final Habit habit;

  const HabitDetailsPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          habit.title,
          style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black54), 
            onPressed: () { context.push('/create', extra: habit);
          }),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red), 
            onPressed: () {
              showDialog(
        context: context,
        builder: (dialogContext) => DeleteHabitDialog(
          onConfirm: () {
            context.read<HabitBloc>().add(DeleteHabit(habit.id));
            Navigator.pop(dialogContext);
            Navigator.pop(context);
          },
        ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Streak and Completion Row
            Row(
              children: [
                Expanded(child: _buildStatCard("CURRENT STREAK", "${habit.streak}", "days", isStreak: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard("COMPLETION", "88", "%", isProgress: true)),
              ],
            ),
            const SizedBox(height: 24),

            // Activity History Card
            _buildActivityCard(),

            const SizedBox(height: 24),

            // Growth Momentum Card
            _buildMomentumCard(),
            
            const SizedBox(height: 40),

            // Mark Today Done Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  context.read<HabitBloc>().add(
                    ToggleHabitStatus(habit.id),
                  );
                  context.pop();
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text("Mark Today Done", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit, {bool isStreak = false, bool isProgress = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          if (isStreak) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Text("BEST: 21", style: TextStyle(fontSize: 10, color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
            )
          ],
          if (isProgress) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(value: 0.88, backgroundColor: Colors.grey[200], color: AppTheme.primaryColor, minHeight: 6),
          ]
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Activity History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Last 6 Months", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          // Heatmap grid 
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(60, (index) {

              final bool isDayMarked = index % 3 != 0;

              return Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isDayMarked 
                    ? AppTheme.primaryColor 
                    : Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentumCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Growth Momentum", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            "You've maintained your streak for ${habit.streak} days straight. You're in the top 5% of early risers this week.",
            style: const TextStyle(color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }
}