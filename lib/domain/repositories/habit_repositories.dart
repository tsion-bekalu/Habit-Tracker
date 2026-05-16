import '../entities/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> getHabits();
  Future<void> createHabit(Habit habit);
  Future<void> updateHabit(Habit habit);
  Future<void> deleteHabit(int id);
}