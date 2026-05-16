import 'package:flutter/material.dart';
import '../../domain/entities/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const HabitCard({super.key, required this.habit, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF864CD2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(habit.title),
              color: const Color(0xFF864CD2),
            ),
          ),
          const SizedBox(width: 16),
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (habit.description.isNotEmpty) ...[
                  const SizedBox(height: 4),

                  Text(
                    habit.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),
                ],

                Row(
                  children: [
                    const Text("🔥 ", style: TextStyle(fontSize: 12)),
                    Text(
                      "${habit.streak} days",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    if (habit.isCompleted) ...[
                      const Text(" • ", style: TextStyle(color: Colors.grey)),
                      const Text(
                        "COMPLETED",
                        style: TextStyle(
                          color: Color(0xFF864CD2),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
          // Checkmark Button
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: habit.isCompleted ? const Color(0xFF864CD2) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: habit.isCompleted ? const Color(0xFF864CD2) : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.check,
                size: 20,
                color: habit.isCompleted ? Colors.white : Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String title) {
    if (title.toLowerCase().contains('water')) return Icons.water_drop_outlined;
    if (title.toLowerCase().contains('workout')) return Icons.fitness_center;
    if (title.toLowerCase().contains('read')) return Icons.menu_book;
    return Icons.self_improvement;
  }
}