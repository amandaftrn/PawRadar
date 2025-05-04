import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome banner
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to PawRadar!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your pet care companion',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Quick actions
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly distribute action buttons
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.add,
                    label: 'Add Pet',
                    color: Colors.green,
                    onTap: () {
                      // Navigate to add pet screen
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Add pet functionality coming soon!'))
                      );
                    },
                  ),
                ),
                SizedBox(width: 8), // Consistent spacing between buttons
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.calendar_today,
                    label: 'Schedule',
                    color: Colors.orange,
                    onTap: () {
                      // Navigate to schedule screen
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Schedule functionality coming soon!'))
                      );
                    },
                  ),
                ),
                SizedBox(width: 8), // Consistent spacing between buttons
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.local_hospital,
                    label: 'Vet',
                    color: Colors.red,
                    onTap: () {
                      // Navigate to vet info screen
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Vet information coming soon!'))
                      );
                    },
                  ),
                ),
                SizedBox(width: 8), // Consistent spacing between buttons
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    icon: Icons.pets,
                    label: 'Care',
                    color: Colors.purple,
                    onTap: () {
                      // Navigate to care screen
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Care guides coming soon!'))
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Upcoming appointments
          Text(
            'Upcoming Appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildAppointmentCard(
            context,
            petName: 'Max',
            appointmentType: 'Vaccination',
            date: 'May 10, 2023',
            time: '10:00 AM',
            icon: Icons.medical_services,
            color: Colors.blue,
          ),
          SizedBox(height: 8),
          _buildAppointmentCard(
            context,
            petName: 'Bella',
            appointmentType: 'Grooming',
            date: 'May 15, 2023',
            time: '2:30 PM',
            icon: Icons.spa,
            color: Colors.pink,
          ),

          SizedBox(height: 24),

          // Health tips
          Text(
            'Pet Health Tips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildTipCard(
            context,
            title: 'Summer Care',
            description: 'Keep your pet hydrated and provide shade during hot days.',
            icon: Icons.wb_sunny,
          ),
          SizedBox(height: 8),
          _buildTipCard(
            context,
            title: 'Regular Exercise',
            description: 'Make sure your pet gets regular exercise to maintain health.',
            icon: Icons.directions_run,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryWidget({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String count,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 28,
        ),
        SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context, {
        required String petName,
        required String appointmentType,
        required String date,
        required String time,
        required IconData icon,
        required Color color,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$appointmentType for $petName',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$date at $time',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
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