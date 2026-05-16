import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/core/network/dio_client.dart';
import '../../data/repositories/habit_repositories.dart';
import '../../presentation/blocs/habit/habit_bloc.dart';
import '../../presentation/blocs/habit/habit_event.dart';
import '../../domain/repositories/habit_repositories.dart';
import 'core/navigation/app_router.dart';

void main() {
  final dioClient = DioClient(); 
  final habitRepository = HabitRepositoryImpl(dioClient.dio);

  runApp(
    RepositoryProvider<HabitRepository>(
      create: (context) => habitRepository,
      child: BlocProvider(
        create: (context) => HabitBloc(
          context.read<HabitRepository>(),)..add(FetchHabits()),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins', // If you have it in pubspec
      ),
    );
  }
}