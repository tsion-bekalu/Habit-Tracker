import '../../domain/entities/habit.dart';

class HabitModel extends Habit {
  const HabitModel({
    required super.id,
    required super.title,
    required super.description,
    required super.frequency,
    required super.startDate,
    required super.reminderEnabled,
    super.streak,
    super.isCompleted,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] ?? 0,
      
      // 'todo' from API becomes title
      title: json['todo'] ?? '',

      // DummyJSON todos do not have descriptions
      description: '',

      // These fields do not exist in API
      // so we give default values
      
      frequency: json['frequency'] ?? 'Daily',
      
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      
      reminderEnabled: json['reminderEnabled'] ?? false,

      isCompleted: json['completed'] ?? false,
      
      streak: json['streak'] ?? 0,
  );
  }

  Map<String, dynamic> toJson() {
    return {
      'todo': title,
      'completed': isCompleted,
      'frequency': frequency,
      'startDate': startDate.toIso8601String(),
      'reminderEnabled': reminderEnabled,
    };
  }
}