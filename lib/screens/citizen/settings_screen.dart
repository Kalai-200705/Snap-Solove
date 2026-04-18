import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/issue_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool isNotificationOn = true;

  bool dataSaver = false;
  bool sound = true;
  bool vibration = true;
  bool appLock = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  /// 🔄 Load saved settings
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      dataSaver = prefs.getBool('dataSaver') ?? false;
      sound = prefs.getBool('sound') ?? true;
      vibration = prefs.getBool('vibration') ?? true;
      appLock = prefs.getBool('appLock') ?? false;
      isDarkMode = prefs.getBool('darkMode') ?? false;
      isNotificationOn = prefs.getBool('notifications') ?? true;
    });
  }

  /// 💾 Save settings
  Future<void> saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /// 📄 Generate PDF of complaint history
  Future<void> generatePDF(List<Issue> complaints) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Complaint History',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              ...complaints.map(
                (complaint) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Text(
                    'Title: ${complaint.title}\n'
                    'Description: ${complaint.description}\n'
                    'Status: ${complaint.status}\n'
                    'Location: ${complaint.lat}, ${complaint.lng}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          /// 🌙 Dark Mode
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: isDarkMode,
            onChanged: (value) async {
              setState(() {
                isDarkMode = value;
              });
              await saveSetting('darkMode', value);
            },
          ),

          /// 🔔 Notifications
          SwitchListTile(
            title: const Text("Notifications"),
            value: isNotificationOn,
            onChanged: (value) async {
              setState(() {
                isNotificationOn = value;
              });
              await saveSetting('notifications', value);
            },
            secondary: const Icon(Icons.notifications),
          ),

          const Divider(),

          /// 📶 Data Saver
          SwitchListTile(
            title: const Text("Data Saver Mode"),
            subtitle: const Text("Reduce data usage"),
            value: dataSaver,
            onChanged: (value) async {
              setState(() {
                dataSaver = value;
              });

              await saveSetting('dataSaver', value);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value
                        ? "Data Saver Enabled (Low data mode ON)"
                        : "Data Saver Disabled (Normal mode ON)",
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            secondary: const Icon(Icons.data_usage),
          ),

          /// 🔊 Sound
          SwitchListTile(
            title: const Text("Notification Sound"),
            value: sound,
            onChanged: (value) async {
              setState(() {
                sound = value;
              });

              await saveSetting('sound', value);

              if (value) {
                final player = AudioPlayer();
                await player.play(AssetSource('sounds/notify.mp3'));
              }
            },
            secondary: const Icon(Icons.volume_up),
          ),

          /// 📳 Vibration
          SwitchListTile(
            title: const Text("Vibration"),
            value: vibration,
            onChanged: (value) async {
              setState(() {
                vibration = value;
              });

              await saveSetting('vibration', value);

              if (value && await Vibration.hasVibrator() == true) {
                await Vibration.vibrate(duration: 100);
              }
            },
            secondary: const Icon(Icons.vibration),
          ),

          const Divider(),

          /// 📥 Download History
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text("Download Complaint History"),
            subtitle: const Text("Export as PDF"),
            onTap: () {
              final complaints = <Issue>[
                Issue(
                  title: 'Pothole',
                  description: 'Large pothole on Main St',
                  status: 'Resolved',
                  lat: 0.0,
                  lng: 0.0,
                ),
                Issue(
                  title: 'Broken Light',
                  description: 'Street light not working',
                  status: 'Pending',
                  lat: 0.0,
                  lng: 0.0,
                ),
              ];
              generatePDF(complaints);
            },
          ),

          const Divider(),

          /// ℹ️ About
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About App"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "SnapSolve",
                applicationVersion: "1.0",
                children: const [
                  Text("Citizen reporting app"),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
