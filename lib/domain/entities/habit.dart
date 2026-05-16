import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  final int id;
  final String title;
  final String description;
  final String frequency;
  final DateTime startDate;
  final bool reminderEnabled;
  final int streak;       // We'll map 'reactions' or a random number to this
  final bool isCompleted;

  const Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.startDate,
    required this.reminderEnabled,
    this.streak = 0,
    this.isCompleted = false,
  });

  Habit copyWith({
    String? title,
    String? description,
    String? frequency,
    DateTime? startDate,
    bool? reminderEnabled,
    int? streak,
    bool? isCompleted
    }) {
    return Habit(
      id: this.id, // ID never changes
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate ,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      streak: streak ?? this.streak,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, description, streak, isCompleted];
}