import 'package:flutter/material.dart';

class HealthChartScreen extends StatelessWidget {
  final List<HealthData> _healthData = [
    HealthData('Mon', 8.5),
    HealthData('Tue', 9.2),
    HealthData('Wed', 8.8),
    HealthData('Thu', 9.5),
    HealthData('Fri', 9.0),
    HealthData('Sat', 8.7),
    HealthData('Sun', 9.3),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Simple Bar Chart
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Activity Hours',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _healthData.map((data) {
                        // Calculate max value to normalize the bars
                        double maxValue = _healthData.map((e) => e.value).reduce((a, b) => a > b ? a : b);
                        // Reserve space for labels (50px) and spacing (8px)
                        double availableHeight = 200 - 50 - 8;
                        double barHeight = (data.value / maxValue) * availableHeight;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _showBarInfo(context, data),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Value label on top of bar
                                Text(
                                  '${data.value}h',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  width: 30,
                                  height: barHeight,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        Theme.of(context).primaryColor.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  data.day,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Health Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Weight', '25.5 kg', Icons.monitor_weight, Colors.blue),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Steps', '12,450', Icons.directions_walk, Colors.green),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Additional Health Metrics
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Heart Rate', '72 bpm', Icons.favorite, Colors.red),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Sleep', '8.5 hrs', Icons.bedtime, Colors.purple),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(title, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showBarInfo(BuildContext context, HealthData data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${data.day} Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Activity Hours: ${data.value}h'),
            Text('Status: ${data.value >= 9.0 ? "Great!" : "Good"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class HealthData {
  final String day;
  final double value;

  HealthData(this.day, this.value);
}