import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isMapLoading = true;
  List<PetLocation> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _locations = [
        PetLocation('Mickey', 'Central Park', -6.2088, 106.8456, DateTime.now().subtract(Duration(minutes: 15))),
        PetLocation('Chiki', 'Home', -6.2090, 106.8458, DateTime.now().subtract(Duration(hours: 1))),
        PetLocation('Bam', 'Vet Clinic', -6.2085, 106.8460, DateTime.now().subtract(Duration(hours: 2))),
        PetLocation('Mickey', 'Dog Park', -6.2092, 106.8462, DateTime.now().subtract(Duration(hours: 4))),
      ];
      _isMapLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with live tracking status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pet Locations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Live Tracking',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Interactive Map Simulation
          Card(
            elevation: 4,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: _isMapLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading map...'),
                  ],
                ),
              )
                  : Stack(
                children: [
                  // Background map simulation
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/400x250/E8F5E8/4CAF50?text=Interactive+Map'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Pet location markers
                  ...List.generate(_locations.length, (index) {
                    final location = _locations[index];
                    return Positioned(
                      left: 50.0 + (index * 80.0),
                      top: 50.0 + (index * 40.0),
                      child: GestureDetector(
                        onTap: () => _showLocationDetails(location),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.pets,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    );
                  }),
                  // Map controls
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: "zoom_in",
                          onPressed: () => _showToast(context, 'Zoom in'),
                          child: Icon(Icons.add),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: "zoom_out",
                          onPressed: () => _showToast(context, 'Zoom out'),
                          child: Icon(Icons.remove),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: "my_location",
                          onPressed: () => _showToast(context, 'Centering map...'),
                          child: Icon(Icons.my_location),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Location History with filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: 'Today',
                items: ['Today', 'Yesterday', 'This Week', 'This Month'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _showToast(context, 'Filtering by $newValue');
                },
              ),
            ],
          ),
          SizedBox(height: 12),

          // Enhanced Location List
          ...List.generate(_locations.length, (index) {
            final location = _locations[index];
            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getPetColor(location.petName),
                  child: Text(
                    location.petName[0],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  '${location.petName} - ${location.locationName}',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_formatTime(location.timestamp)}'),
                    Text(
                      'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.directions, color: Colors.blue),
                      onPressed: () => _showToast(context, 'Opening directions to ${location.locationName}'),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () => _showLocationDetails(location),
              ),
            );
          }),

          SizedBox(height: 20),

          // Quick Actions
          Text(
            'Quick Actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showToast(context, 'Setting up safe zone...'),
                  icon: Icon(Icons.security),
                  label: Text('Set Safe Zone'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showToast(context, 'Sharing location...'),
                  icon: Icon(Icons.share_location),
                  label: Text('Share Location'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLocationDetails(PetLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${location.petName} Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${location.locationName}'),
            Text('Coordinates: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}'),
            Text('Last Updated: ${_formatTime(location.timestamp)}'),
            SizedBox(height: 16),
            Text('Actions:', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast(context, 'Navigating to ${location.petName}...');
            },
            child: Text('Navigate'),
          ),
        ],
      ),
    );
  }

  Color _getPetColor(String petName) {
    switch (petName) {
      case 'Mickey':
        return Colors.blue;
      case 'Chiki':
        return Colors.pink;
      case 'Bam':
        return Colors.green;
      default:
        return Colors.grey;
    }
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
}

class PetLocation {
  final String petName;
  final String locationName;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  PetLocation(this.petName, this.locationName, this.latitude, this.longitude, this.timestamp);
}