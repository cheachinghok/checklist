import 'package:flutter/material.dart';
import 'package:checklist_app/core/models/task_model.dart';
import 'add_task_dialog.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => onToggle(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: task.isCompleted ? Colors.grey : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
            ],
            _buildTaskMeta(context),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPriorityIndicator(task.priority),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') _showEditDialog(context);
                if (value == 'delete') onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskMeta(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (task.dueDate != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getDueDateColor(context),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 12,
                  color: _getDueDateTextColor(context),
                ),
                const SizedBox(width: 2),
                Text(
                  _formatDueDate(task.dueDate!),
                  style: TextStyle(
                    fontSize: 10,
                    color: _getDueDateTextColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ...task.tags.map((tag) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '#$tag',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildPriorityIndicator(TaskPriority priority) {
    Color color;
    String label;
    
    switch (priority) {
      case TaskPriority.low:
        color = Colors.green;
        label = 'L';
        break;
      case TaskPriority.medium:
        color = Colors.blue;
        label = 'M';
        break;
      case TaskPriority.high:
        color = Colors.orange;
        label = 'H';
        break;
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(taskToEdit: task, edit: true,),
    );
  }

  Color _getDueDateColor(BuildContext context) {
    if (task.dueDate!.isBefore(DateTime.now())) {
      return Colors.red.shade100;
    } else if (task.dueDate!.difference(DateTime.now()).inDays <= 1) {
      return Colors.orange.shade100;
    }
    return Colors.green.shade100;
  }

  Color _getDueDateTextColor(BuildContext context) {
    if (task.dueDate!.isBefore(DateTime.now())) {
      return Colors.red.shade800;
    } else if (task.dueDate!.difference(DateTime.now()).inDays <= 1) {
      return Colors.orange.shade800;
    }
    return Colors.green.shade800;
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.inDays == 0) {
      return 'Today ${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow ${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 0) {
      return 'Overdue';
    } else {
      return '${difference.inDays}d left';
    }
  }
}