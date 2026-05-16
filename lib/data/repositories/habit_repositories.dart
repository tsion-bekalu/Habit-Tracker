import 'package:dio/dio.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repositories.dart'; // Must import the abstract class
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final Dio _dio;

  // Passing Dio through the constructor is better for testing
  HabitRepositoryImpl(this._dio);

  @override
  Future<List<Habit>> getHabits() async {
    try {
      final response = await _dio.get('https://dummyjson.com/todos');
      final List data = response.data['todos'];
      // We convert the Models (Data) into Entities (Domain) here
      return data.map<Habit>((json) => HabitModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Failed to load habits");
    }
  }

  @override
  Future<void> deleteHabit(int id) async {
    await _dio.delete('https://dummyjson.com/todos/$id');
  }

  @override
  Future<void> createHabit(Habit habit) async {
    try {
      await _dio.post(
        'https://dummyjson.com/todos/add',
        data: {
        'todo': habit.title,
        'body': habit.description,
        'frequency': habit.frequency,
        'startDate': habit.startDate.toIso8601String(),
        'reminderEnabled': habit.reminderEnabled,
        'completed': habit.isCompleted,
        },
      );
    } catch (e) {
      throw Exception("Failed to save habit to server");
    }
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await _dio.put('https://dummyjson.com/todos/${habit.id}', 
    data: {
      'todo': habit.title,
    'completed': habit.isCompleted,
    });
  }
}