import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/habit_repositories.dart';
import '../../../domain/entities/habit.dart';
import 'habit_event.dart';
import 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository repository;

  HabitBloc(this.repository) : super(HabitInitial()) {
    
    // --- READ ---
    on<FetchHabits>((event, emit) async {
      emit(HabitLoading());
      try {
        final habits = await repository.getHabits();
        emit(HabitLoaded(habits));
      } catch (e) {
        emit(HabitError("Failed to fetch habits: ${e.toString()}"));
      }
    });

    // --- CREATE ---
    on<AddHabit>((event, emit) async {
      if (state is HabitLoaded) {
        final currentState = state as HabitLoaded;
        
        // 1. Create the new Habit entity
        final newHabit = Habit(
          id: DateTime.now().millisecondsSinceEpoch, // Unique ID
          title: event.title,
          description: event.description,
          frequency: event.frequency,
          startDate: event.startDate,
          reminderEnabled: event.reminderEnabled,
          streak: 0,
          isCompleted: false,
        );

        // 2. Emit the new state with the added habit
        final updatedList = List<Habit>.from(currentState.habits)..add(newHabit);
        emit(HabitLoaded(updatedList));

        // 3. Logic to tell Dio to save it to the server (dummyJSON)
        try {
          await repository.createHabit(newHabit);
        } catch (e) {
          // Handle error if needed
        }
      }
    });

    // --- UPDATE ---
    on<UpdateHabit>((event, emit) async {
      if (state is HabitLoaded) {
        final currentState = state as HabitLoaded;

        final updatedList = currentState.habits.map((h) {
          return h.id == event.habit.id ? event.habit : h;
        }).toList();

        emit(HabitLoaded(updatedList));

        try {
          await repository.updateHabit(event.habit);
        } catch (e) {
          emit(HabitError("Update failed"));
        }
      }
    });

    // --- DELETE ---
    on<DeleteHabit>((event, emit) async {
      if (state is HabitLoaded) {
        final currentHabits = (state as HabitLoaded).habits;
        try {
          // Optimistic UI: Remove it locally first so the UI feels snappy
          final updatedList = currentHabits.where((h) => h.id != event.habitId).toList();
          emit(HabitLoaded(updatedList));

          await repository.deleteHabit(event.habitId);
        } catch (e) {
          // If server delete fails, re-fetch to bring back the missing item
          add(FetchHabits());
          emit(HabitError("Delete failed. Please try again."));
        }
      }
    });

    //Toggle
    on<ToggleHabitStatus>((event, emit) async {
      if (state is HabitLoaded) {
        final currentState = state as HabitLoaded;

        Habit? updatedHabit;

        final updatedHabits = currentState.habits.map((habit) {
          if (habit.id == event.habitId) {
            updatedHabit = habit.copyWith(
              isCompleted: !habit.isCompleted,
            );

            return updatedHabit!;
          }

          return habit;
        }).toList();

        emit(HabitLoaded(updatedHabits));

        try {
          await repository.updateHabit(updatedHabit!);
        } catch (e) {
          emit(HabitError("Failed to update habit"));
        }
      }
    });
  }
}