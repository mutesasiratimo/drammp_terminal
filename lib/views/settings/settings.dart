import 'package:entebbe_dramp_terminal/config/base.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends Base<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
                subtitle: Text(
                  "View/Edit your profile",
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
              ListTile(
                leading: Icon(Icons.auto_graph_rounded),
                title: Text("Reports"),
                subtitle: Text(
                  "Export PDF copies here",
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
              ListTile(
                leading: Icon(Icons.traffic_sharp),
                title: Text("Trips"),
                subtitle: Text(
                  "View trip history",
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
              ListTile(
                leading: Icon(Icons.help_center),
                title: Text("Help Center"),
                subtitle: Text(
                  "Contact Driver Assistance",
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
              ListTile(
                leading: Icon(Icons.sos),
                title: Text("SOS"),
                subtitle: Text(
                  "Contact Emergency Services",
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  clearPrefs();
                },
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                subtitle: Text(
                  "Password will be required",
                ),
                subtitleTextStyle: TextStyle(
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
