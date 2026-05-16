import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/habit/habit_bloc.dart';
import '../blocs/habit/habit_state.dart';
import '../blocs/habit/habit_event.dart';
import '../widgets/habit_card.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TOP HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Habit Tracker',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/pprofile.png'), // Matches Body_2.png
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- SUMMARY CARDS (Goal & Streak) ---
              Row(
                children: [
                  _buildSummaryCard(
                    title: "DAILY GOAL",
                    value: "85%",
                    subValue: "done",
                    color: Colors.white,
                    textColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 15),
                  _buildSummaryCard(
                    title: "STREAK",
                    value: "12",
                    subValue: "days",
                    color: AppTheme.primaryColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- SECTION TITLE ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Habits",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('MMMM d, y').format(DateTime.now()),
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- BLOC BUILDER FOR HABITS ---
              BlocBuilder<HabitBloc, HabitState>(
                builder: (context, state) {
                  if (state is HabitLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HabitLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.habits.length,
                      itemBuilder: (context, index) {
                        final habit = state.habits[index];
                        return GestureDetector(
                          onTap: () => context.push('/details', extra: habit),
                          child: HabitCard(
                          habit: habit,
                          onToggle: () {
                            context.read<HabitBloc>().add(ToggleHabitStatus(habit.id));
                          },
                        ),);
                      },
                    );
                  } else if (state is HabitError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
              
              // --- HEATMAP PLACEHOLDER ---
              _buildHeatmapSection(),
            ],
          ),
        ),
      ),
      // --- FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create'),
        backgroundColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  // Helper for Goal/Streak Cards
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subValue,
    required Color color,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (color == Colors.white)
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(value, style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(width: 4),
                Text(subValue, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapSection() {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "WEEKLY HEATMAP", 
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Spread the generated boxes into the Row's children
            ...List.generate(7, (index) => Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                // index 3 and 6 are grey placeholders like in Body_2.png
                color: index == 3 || index == 6 
                    ? Colors.grey[200] 
                    : AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
            )),
            // Now the Text widget sits happily as a sibling to the containers
            const Text(
              "82%", 
              style: TextStyle(
                color: AppTheme.primaryColor, 
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ],
    ),
  );
}
}