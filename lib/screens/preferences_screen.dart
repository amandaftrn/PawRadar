import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _notifications = true;
  bool _locationTracking = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Notifications
          SwitchListTile(
            title: Text('Push Notifications'),
            subtitle: Text('Receive alerts for pet activities'),
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _notifications ? 'Notifications enabled' : 'Notifications disabled',
                  ),
                ),
              );
            },
          ),

          // Location Tracking
          SwitchListTile(
            title: Text('Location Tracking'),
            subtitle: Text('Track your pets location'),
            value: _locationTracking,
            onChanged: (value) {
              setState(() {
                _locationTracking = value;
              });
            },
          ),

          Divider(),

          // Language Selector
          ListTile(
            title: Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Select Language'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ['English', 'Bahasa Indonesia', 'Español'].map(
                          (lang) => RadioListTile<String>(
                        title: Text(lang),
                        value: lang,
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ).toList(),
                  ),
                ),
              );
            },
          ),

          // Theme Selector
          ListTile(
            title: Text('Theme'),
            subtitle: Text(_selectedTheme),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Select Theme'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Light', 'Dark', 'Auto'].map(
                          (theme) => RadioListTile<String>(
                        title: Text(theme),
                        value: theme,
                        groupValue: _selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ).toList(),
                  ),
                ),
              );
            },
          ),

          Divider(),

          // Logout
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}