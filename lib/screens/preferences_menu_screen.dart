import 'package:flutter/material.dart';

class PreferencesMenuScreen extends StatefulWidget {
  const PreferencesMenuScreen({Key? key}) : super(key: key);

  @override
  _PreferencesMenuScreenState createState() => _PreferencesMenuScreenState();
}

class _PreferencesMenuScreenState extends State<PreferencesMenuScreen> {
  // Preferences variables
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoBackupEnabled = true;
  String _selectedLanguage = 'Bahasa Indonesia';
  String _selectedTheme = 'Default';
  double _reminderFrequency = 2.0; // hours

  final List<String> _languages = [
    'Bahasa Indonesia',
    'English',
  ];

  final List<String> _themes = [
    'Default',
    'Dark',
    'Light',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings & Menu'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            _buildProfileSection(),

            // Menu Options
            _buildMenuSection(),

            // Preferences Section
            _buildPreferencesSection(),

            // About Section
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 35,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pet Owner',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'pawradar@email.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _showEditProfileDialog();
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildMenuTile(
            icon: Icons.medical_services,
            title: 'Medical Records',
            subtitle: 'View pet medical history',
            onTap: () {
              _showToast('Opening Medical Records...');
            },
          ),
          _buildMenuTile(
            icon: Icons.calendar_today,
            title: 'Appointment History',
            subtitle: 'View past and upcoming appointments',
            onTap: () {
              _showToast('Opening Appointment History...');
            },
          ),
          _buildMenuTile(
            icon: Icons.receipt,
            title: 'Bills & Payments',
            subtitle: 'Manage your payments',
            onTap: () {
              _showToast('Opening Bills & Payments...');
            },
          ),
          _buildMenuTile(
            icon: Icons.location_on,
            title: 'Nearby Services',
            subtitle: 'Find services near you',
            onTap: () {
              _showToast('Finding nearby services...');
            },
          ),
          _buildMenuTile(
            icon: Icons.support,
            title: 'Customer Support',
            subtitle: 'Get help and support',
            onTap: () {
              _showSupportDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Notification Settings
          ExpansionTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            children: [
              _buildSwitchTile(
                title: 'Enable Notifications',
                subtitle: 'Receive app notifications',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  _showToast('Notifications ${value ? 'enabled' : 'disabled'}');
                },
              ),
              _buildSwitchTile(
                title: 'Sound',
                subtitle: 'Play notification sounds',
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Vibration',
                subtitle: 'Vibrate on notifications',
                value: _vibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    _vibrationEnabled = value;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reminder Frequency'),
                    Slider(
                      value: _reminderFrequency,
                      min: 1.0,
                      max: 24.0,
                      divisions: 23,
                      label: '${_reminderFrequency.round()} hours',
                      onChanged: (value) {
                        setState(() {
                          _reminderFrequency = value;
                        });
                      },
                    ),
                    Text('Every ${_reminderFrequency.round()} hours'),
                  ],
                ),
              ),
            ],
          ),

          // Display Settings
          ExpansionTile(
            leading: Icon(Icons.display_settings),
            title: Text('Display'),
            children: [
              _buildSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                  _showToast('Dark mode ${value ? 'enabled' : 'disabled'}');
                },
              ),
              ListTile(
                title: Text('Theme Color'),
                subtitle: Text(_selectedTheme),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showThemeSelector();
                },
              ),
            ],
          ),

          // Language & Region
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showLanguageSelector();
            },
          ),

          // Backup Settings
          _buildSwitchTile(
            title: 'Auto Backup',
            subtitle: 'Automatically backup your data',
            value: _autoBackupEnabled,
            leading: Icon(Icons.backup),
            onChanged: (value) {
              setState(() {
                _autoBackupEnabled = value;
              });
              _showToast('Auto backup ${value ? 'enabled' : 'disabled'}');
            },
          ),

          // Privacy Settings
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Settings'),
            subtitle: Text('Manage your privacy preferences'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _showPrivacyDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.info,
            title: 'About PawRadar',
            subtitle: 'Version 1.0.0',
            onTap: () {
              _showAboutDialog();
            },
          ),
          _buildMenuTile(
            icon: Icons.help,
            title: 'Help & FAQ',
            subtitle: 'Get help and find answers',
            onTap: () {
              _showToast('Opening Help & FAQ...');
            },
          ),
          _buildMenuTile(
            icon: Icons.rate_review,
            title: 'Rate App',
            subtitle: 'Rate us on the App Store',
            onTap: () {
              _showToast('Thank you for your interest in rating us!');
            },
          ),
          _buildMenuTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Widget? leading,
  }) {
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // Dialog methods
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast('Profile updated successfully!');
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                _showToast('Language changed to $value');
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Theme Color'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themes.map((theme) {
            return RadioListTile<String>(
              title: Text(theme),
              value: theme,
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
                _showToast('Theme changed to $value');
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Customer Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help? Contact us:'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text('support@pawradar.com'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text('+62 123 456 789'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text('24/7 Support'),
              ],
            ),
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
              _showToast('Opening support chat...');
            },
            child: Text('Chat Now'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text('Share usage data'),
              subtitle: Text('Help improve the app'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Location tracking'),
              subtitle: Text('For nearby services'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Marketing emails'),
              subtitle: Text('Receive promotional emails'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast('Privacy settings updated!');
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About PawRadar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PawRadar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text('Your complete pet care companion. Manage your pets, schedule appointments, and keep track of their health and wellbeing.'),
            SizedBox(height: 16),
            Text('© 2023 PawRadar Team'),
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

  void _showLogoutDialog() {
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast('Logged out successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}