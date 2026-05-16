import 'package:go_router/go_router.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/create_habit.dart';
import '../../presentation/screens/habit_details_screen.dart';
import '../../domain/entities/habit.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/create',
        builder: (context, state) {
          final habit = state.extra as Habit?;
          return CreateHabitPage(habit: habit);
        },
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) {
          final habit = state.extra as Habit; 
          return HabitDetailsPage(habit: habit);
        },
      ),
    ],
  );
}