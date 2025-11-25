import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:checklist_app/core/models/task_model.dart';

class CompletionChart extends StatelessWidget {
  final List<Task> tasks;

  const CompletionChart({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((task) => task.isCompleted).length;
    final pending = tasks.length - completed;
    final priority = tasks.where((task) => task.priority == TaskPriority.high).length;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Completion',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: completed.toDouble(),
                      color: Colors.green,
                      title: '$completed',
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: completed.toDouble(),
                      color: Colors.blue,
                      title: '$priority',
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: pending.toDouble(),
                      color: Colors.orange,
                      title: '$pending',
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegend(Colors.green, 'Completed', completed),
                _buildLegend(Colors.blue, 'priority', priority),
                _buildLegend(Colors.orange, 'Pending', pending),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label, int count) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text('$label: $count'),
      ],
    );
  }
}