import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/todo.dart';
import '../providers/todo_provider.dart';

class AddTodoScreen extends ConsumerStatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends ConsumerState<AddTodoScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _tagController = TextEditingController();

  bool _isImportant = false;
  Color _statusColor = Colors.green;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final List<String> _tags = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isNotEmpty && !_tags.contains(trimmed)) {
      setState(() => _tags.add(trimmed));
      _tagController.clear();
    }
  }

  void _addTask() {
    final title = _titleController.text.trim();
    final description = _descController.text.trim();

    if (title.isEmpty || _selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields properly')),
      );
      return;
    }

    ref.read(todoProvider.notifier).addTodo(
      title: title,
      description: description,
      tags: _tags,
      date: _selectedDate!,
      startTime: _startTime!.format(context),
      endTime: _endTime!.format(context),
      isImportant: _isImportant,
      statusColor: _statusColor,
    );

    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _selectTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            _sectionTitle('Task Details'),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Tags (type and press space)'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  onDeleted: () => setState(() => _tags.remove(tag)),
                );
              }).toList(),
            ),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(
                hintText: 'Add tag and press space',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                if (value.endsWith(' ')) {
                  _addTag(value.trim());
                }
              },
              onSubmitted: (value) => _addTag(value),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Schedule'),
            const SizedBox(height: 8),
            _buildListTile(
              title: 'Pick Date *',
              subtitle: _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : 'No date selected',
              icon: Icons.calendar_today,
              onTap: _selectDate,
            ),
            _buildListTile(
              title: 'Start Time *',
              subtitle: _startTime != null ? _startTime!.format(context) : 'No start time selected',
              icon: Icons.access_time,
              onTap: () => _selectTime(true),
            ),
            _buildListTile(
              title: 'End Time *',
              subtitle: _endTime != null ? _endTime!.format(context) : 'No end time selected',
              icon: Icons.access_time,
              onTap: () => _selectTime(false),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Preferences'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Mark as Important'),
                const Spacer(),
                Switch(
                  value: _isImportant,
                  activeColor: theme.colorScheme.primary,
                  onChanged: (value) => setState(() => _isImportant = value),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status Color'),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showColorPicker(context),
                  child: CircleAvatar(
                    backgroundColor: _statusColor,
                    radius: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addTask,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'Add Task',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
      ),
      trailing: Icon(icon, color: theme.colorScheme.primary),
      onTap: onTap,
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pick Status Color'),
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.red,
            Colors.purple,
            Colors.pink,
            Colors.teal,
            Colors.amber,
          ].map((color) {
            return GestureDetector(
              onTap: () {
                setState(() => _statusColor = color);
                Navigator.of(context).pop();
              },
              child: CircleAvatar(backgroundColor: color, radius: 20),
            );
          }).toList(),
        ),
      ),
    );
  }
}
