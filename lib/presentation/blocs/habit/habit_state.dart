import 'package:equatable/equatable.dart';
import '../../../domain/entities/habit.dart';

abstract class HabitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HabitInitial extends HabitState {}

class HabitLoading extends HabitState {}

class HabitLoaded extends HabitState {
  final List<Habit> habits;
  HabitLoaded(this.habits);

  @override
  List<Object?> get props => [habits];
}

class HabitError extends HabitState {
  final String message;
  HabitError(this.message);

  @override
  List<Object?> get props => [message];
}