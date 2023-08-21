import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedCurrency = 'USD';
  String selectedLanguage = 'English';
  String selectedDateFormat = 'MM/dd/yyyy';
  bool notificationsEnabled = false;
  bool backupEnabled = false;

  List<String> currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
  ];

  List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
  ];

  List<String> dateFormats = [
    'MM/dd/yyyy',
    'dd/MM/yyyy',
    'yyyy-MM-dd',
  ];

  void updateCurrency(String value) {
    setState(() {
      selectedCurrency = value;
    });
  }

  void updateLanguage(String value) {
    setState(() {
      selectedLanguage = value;
    });
  }

  void updateDateFormat(String value) {
    setState(() {
      selectedDateFormat = value;
    });
  }

  void toggleNotifications(bool value) {
    setState(() {
      notificationsEnabled = value;
    });
  }

  void toggleBackup(bool value) {
    setState(() {
      backupEnabled = value;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 235, 210, 210),
    appBar: AppBar(
      title: const Text('Settings'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: const Text('Currency'),
          trailing: DropdownButton<String>(
            value: selectedCurrency,
            onChanged: (newValue) {
              setState(() {
                selectedCurrency = newValue!;
              });
            },
            items: currencies.map((currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Language'),
          trailing: DropdownButton<String>(
            value: selectedLanguage,
            onChanged: (newValue) {
              setState(() {
                selectedLanguage = newValue!;
              });
            },
            items: languages.map((language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
          ),
        ),
        ListTile(
          title: const Text('Date Format'),
          trailing: DropdownButton<String>(
            value: selectedDateFormat,
            onChanged: (newValue) {
              setState(() {
                selectedDateFormat = newValue!;
              });
            },
            items: dateFormats.map((format) {
              return DropdownMenuItem<String>(
                value: format,
                child: Text(format),
              );
            }).toList(),
          ),
        ),
        SwitchListTile(
          title: const Text('Notifications'),
          value: notificationsEnabled,
          onChanged: (newValue) {
            setState(() {
              notificationsEnabled = newValue;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Backup'),
          value: backupEnabled,
          onChanged: (newValue) {
            setState(() {
              backupEnabled = newValue;
            });
          },
        ),
      ],
    ),
  );
}
}
