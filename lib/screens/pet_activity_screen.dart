import 'package:flutter/material.dart';

class PetActivityScreen extends StatefulWidget {
  @override
  _PetActivityScreenState createState() => _PetActivityScreenState();
}

class _PetActivityScreenState extends State<PetActivityScreen> {
  final List<Activity> _activities = [];
  final List<Activity> _filteredActivities = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _selectedPet = 'All Pets';
  String _selectedActivity = 'All Activities';

  final List<String> _petNames = ['All Pets', 'Mickey', 'Chiki', 'Bam'];
  final List<String> _activityTypes = ['All Activities', 'Walking', 'Feeding', 'Medicine', 'Grooming', 'Playing'];

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _searchController.addListener(_filterActivities);
  }

  Future<void> _loadActivities() async {
    // Simulate API call
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _activities.clear();
      _activities.addAll([
        Activity('Mickey', 'Walking', DateTime.now().subtract(Duration(hours: 1)), false),
        Activity('Chiki', 'Feeding', DateTime.now().subtract(Duration(hours: 2)), true),
        Activity('Mickey', 'Medicine', DateTime.now().subtract(Duration(hours: 3)), true),
        Activity('Chiki', 'Grooming', DateTime.now().subtract(Duration(hours: 4)), false),
        Activity('Bam', 'Playing', DateTime.now().subtract(Duration(minutes: 30)), false),
        Activity('Mickey', 'Feeding', DateTime.now().subtract(Duration(hours: 6)), true),
        Activity('Bam', 'Walking', DateTime.now().subtract(Duration(hours: 8)), false),
      ]);
      _isLoading = false;
      _filterActivities();
    });
  }

  void _filterActivities() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      _filteredActivities.clear();
      _filteredActivities.addAll(_activities.where((activity) {
        bool matchesSearch = activity.petName.toLowerCase().contains(query) ||
            activity.type.toLowerCase().contains(query);
        bool matchesPet = _selectedPet == 'All Pets' || activity.petName == _selectedPet;
        bool matchesActivity = _selectedActivity == 'All Activities' || activity.type == _selectedActivity;

        return matchesSearch && matchesPet && matchesActivity;
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Section
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar with Autocomplete
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  List<String> suggestions = [];
                  for (var activity in _activities) {
                    suggestions.add(activity.petName);
                    suggestions.add(activity.type);
                  }
                  suggestions = suggestions.toSet().toList(); // Remove duplicates

                  return suggestions.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _searchController.text = selection;
                  _filterActivities();
                },
                fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                  _searchController.text = controller.text;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search pets or activities...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          _searchController.clear();
                          _filterActivities();
                        },
                      )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      _searchController.text = value;
                      _filterActivities();
                    },
                  );
                },
              ),

              SizedBox(height: 16),

              // Filter Dropdowns (Spinners)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedPet,
                      decoration: InputDecoration(
                        labelText: 'Filter by Pet',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _petNames.map((String pet) {
                        return DropdownMenuItem<String>(
                          value: pet,
                          child: Text(pet),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPet = newValue!;
                          _filterActivities();
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedActivity,
                      decoration: InputDecoration(
                        labelText: 'Filter by Activity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _activityTypes.map((String activity) {
                        return DropdownMenuItem<String>(
                          value: activity,
                          child: Text(activity),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedActivity = newValue!;
                          _filterActivities();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Results Counter
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_filteredActivities.length} activities found',
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextButton.icon(
                onPressed: _loadActivities,
                icon: Icon(Icons.refresh),
                label: Text('Refresh'),
              ),
            ],
          ),
        ),

        // Activity List
        Expanded(
          child: _isLoading
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading activities...'),
              ],
            ),
          )
              : _filteredActivities.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No activities found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  'Try adjusting your filters',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: _loadActivities,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredActivities.length,
              itemBuilder: (context, index) {
                final activity = _filteredActivities[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: Checkbox(
                      value: activity.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          activity.isCompleted = value ?? false;
                        });
                        _showToast(
                          context,
                          activity.isCompleted ? 'Activity completed!' : 'Activity marked incomplete',
                        );
                      },
                    ),
                    title: Text(
                      '${activity.petName} - ${activity.type}',
                      style: TextStyle(
                        decoration: activity.isCompleted ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(_formatTime(activity.time)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          activity.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: activity.isCompleted ? Colors.green : Colors.grey,
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                    onTap: () {
                      _showActivityDetails(context, activity);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showActivityDetails(BuildContext context, Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${activity.petName} - ${activity.type}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pet: ${activity.petName}'),
            Text('Activity: ${activity.type}'),
            Text('Time: ${_formatTime(activity.time)}'),
            Text('Status: ${activity.isCompleted ? "Completed" : "Pending"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                activity.isCompleted = !activity.isCompleted;
              });
              Navigator.pop(context);
              _showToast(
                context,
                activity.isCompleted ? 'Activity completed!' : 'Activity marked incomplete',
              );
            },
            child: Text(activity.isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inMinutes}m ago';
    }
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class Activity {
  final String petName;
  final String type;
  final DateTime time;
  bool isCompleted;

  Activity(this.petName, this.type, this.time, this.isCompleted);
}

