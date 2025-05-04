import 'package:flutter/material.dart';

class CareTask {
  final String title;
  final String description;
  final DateTime dueDate;
  final String petName;
  bool isCompleted;

  CareTask({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.petName,
    this.isCompleted = false,
  });
}

class CareChecklistScreen extends StatefulWidget {
  const CareChecklistScreen({Key? key}) : super(key: key);

  @override
  _CareChecklistScreenState createState() => _CareChecklistScreenState();
}

class _CareChecklistScreenState extends State<CareChecklistScreen> {
  final List<CareTask> _tasks = [];

  // Initialize tasks in initState to avoid DateTime issues
  @override
  void initState() {
    super.initState();

    // Create dates safely
    final now = DateTime.now();

    _tasks.addAll([
      CareTask(
        title: 'Morning Walk',
        description: 'Take Max for a 20-minute morning walk',
        dueDate: DateTime(now.year, now.month, now.day, 8, 0),
        petName: 'Max',
      ),
      CareTask(
        title: 'Evening Walk',
        description: 'Take Max for a 30-minute evening walk',
        dueDate: DateTime(now.year, now.month, now.day, 18, 0),
        petName: 'Max',
      ),
      CareTask(
        title: 'Feed Breakfast',
        description: '1 cup of dry food',
        dueDate: DateTime(now.year, now.month, now.day, 7, 0),
        petName: 'Max',
        isCompleted: true,
      ),
      CareTask(
        title: 'Feed Dinner',
        description: '1 cup of dry food with supplements',
        dueDate: DateTime(now.year, now.month, now.day, 19, 0),
        petName: 'Max',
      ),
      CareTask(
        title: 'Give Medicine',
        description: '1 tablet after breakfast',
        dueDate: DateTime(now.year, now.month, now.day, 8, 30),
        petName: 'Max',
        isCompleted: true,
      ),
      CareTask(
        title: 'Brush Fur',
        description: 'Brush Bella\'s fur for 10 minutes',
        dueDate: DateTime(now.year, now.month, now.day, 16, 0),
        petName: 'Bella',
      ),
      CareTask(
        title: 'Clean Litter Box',
        description: 'Clean Bella\'s litter box',
        dueDate: DateTime(now.year, now.month, now.day, 10, 0),
        petName: 'Bella',
      ),
      CareTask(
        title: 'Feed Breakfast',
        description: '1/2 cup of wet food',
        dueDate: DateTime(now.year, now.month, now.day, 7, 0),
        petName: 'Bella',
        isCompleted: true,
      ),
      CareTask(
        title: 'Feed Dinner',
        description: '1/2 cup of wet food',
        dueDate: DateTime(now.year, now.month, now.day, 19, 0),
        petName: 'Bella',
      ),
    ]);
  }

  // Filter options
  bool _showCompleted = true;
  String _selectedPet = 'All';

  List<CareTask> get _filteredTasks {
    return _tasks.where((task) {
      // Filter by completion status
      if (!_showCompleted && task.isCompleted) {
        return false;
      }

      // Filter by pet name
      if (_selectedPet != 'All' && task.petName != _selectedPet) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with Scaffold if this is going to be used as a standalone screen
    // If it's being used in a TabView, the parent should already have a Scaffold
    return SafeArea(
      child: Column(
        children: [
          // Filter options
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Pet filter dropdown
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPet,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedPet = newValue;
                            });
                          }
                        },
                        items: ['All', 'Max', 'Bella'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Toggle to show/hide completed tasks
                Row(
                  children: [
                    const Text('Show Completed'),
                    Checkbox(
                      value: _showCompleted,
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            _showCompleted = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: _filteredTasks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'No tasks available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                return _buildTaskCard(_filteredTasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(CareTask task) {
    final bool isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                if (value != null) {
                  setState(() {
                    task.isCompleted = value;
                  });

                  if (value == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task completed: ${task.title}'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              task.isCompleted = false;
                            });
                          },
                        ),
                      ),
                    );
                  }
                }
              },
            ),
            const SizedBox(width: 8.0),
            // Task details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: task.isCompleted ? Colors.grey : null,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: isOverdue
                              ? Colors.red.withOpacity(0.1)
                              : task.isCompleted
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          isOverdue
                              ? 'Overdue'
                              : task.isCompleted
                              ? 'Completed'
                              : 'Pending',
                          style: TextStyle(
                            color: isOverdue
                                ? Colors.red
                                : task.isCompleted
                                ? Colors.green
                                : Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    task.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${task.dueDate.hour}:${task.dueDate.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Icon(
                        Icons.pets,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        task.petName,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add Task dialog is accessible via FloatingActionButton
// which should be provided by the parent Scaffold
class CareChecklistPage extends StatelessWidget {
  const CareChecklistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Checklist'),
      ),
      body: const CareChecklistScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    // Task form fields
    String title = '';
    String description = '';
    String petName = 'Max';
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter task title',
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description',
                  ),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Pet',
                  ),
                  value: petName,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      petName = newValue;
                    }
                  },
                  items: ['Max', 'Bella'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (pickedTime != null) {
                      selectedTime = pickedTime;
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    child: Text(
                      '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add new task functionality would go here
                // This would require passing a callback to update state
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New task added!'))
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}