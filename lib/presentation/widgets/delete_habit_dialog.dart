import 'package:flutter/material.dart';

class DeleteHabitDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteHabitDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Matches your screenshot
      ),
      title: const Text(
        "Delete Habit?",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      content: const Text(
        "This action cannot be undone. All habit data will be permanently deleted.",
        style: TextStyle(color: Colors.black54, height: 1.4),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      actions: [
        Row(
          children: [
            // Cancel Button
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5F5F7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context), // Closes dialog box
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Delete Button
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onConfirm, // Executes the deletion logic passed from page
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}