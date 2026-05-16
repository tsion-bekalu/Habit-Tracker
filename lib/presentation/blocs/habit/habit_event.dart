import 'package:equatable/equatable.dart';
import '../../../domain/entities/habit.dart';

abstract class HabitEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchHabits extends HabitEvent {}

class AddHabit extends HabitEvent {
  final String title;
  final String description;
  final String frequency;
  final DateTime startDate;
  final bool reminderEnabled;

  AddHabit({
    required this.title,
    required this.description,
    required this.frequency,
    required this.startDate,
    required this.reminderEnabled,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        frequency,
        startDate,
        reminderEnabled,
      ];
}

class UpdateHabit extends HabitEvent {
  final Habit habit;
  UpdateHabit(this.habit);

  @override
  List<Object?> get props => [habit];
}

class DeleteHabit extends HabitEvent {
  final int habitId;
  DeleteHabit(this.habitId);

  @override
  List<Object?> get props => [habitId];
}

class ToggleHabitStatus extends HabitEvent {
  final int habitId;
  ToggleHabitStatus(this.habitId);
}