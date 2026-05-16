import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            // This centers the children vertically in the column
            mainAxisAlignment: MainAxisAlignment.center,
            // This ensures children like text are centered horizontally
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Only (No icon)
              const Text(
                'Habit Tracker',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF630ED4),
                ),
              ),
              const SizedBox(height: 40),
              
              // Illustration from assets
              Image.asset(
                'assets/illustration.png',
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),
              
              // Text Content
              const Text(
                'Build Better Habits',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w800, 
                  color: Color(0xFF1D1B20),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Track your progress and visualize your consistency with heatmaps.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.grey, 
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              
              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF864CD2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF864CD2).withOpacity(0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started', 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 18, 
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'JOIN 50K+ HABIT BUILDERS',
                style: TextStyle(
                  fontSize: 12, 
                  letterSpacing: 1.2, 
                  color: Colors.grey, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}