import 'package:flutter/material.dart';
import 'package:nfc_classic_mifare/nfc_classic_mifare.dart';

import 'example_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final isAvailable = NfcClassicMifare.availability;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: isAvailable,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            switch (snapshot.data) {
              case AVAILABILITY.AVAILABLE:
                return ExamplePage();

              case AVAILABILITY.NOT_ENABLED:
                return const Scaffold(
                  body: Center(
                    child: Text('NFC Not Enabled.'),
                  ),
                );

              case AVAILABILITY.NOT_SUPPORTED:
                return const Scaffold(
                  body: Center(
                    child: Text('NFC Not Supported.'),
                  ),
                );

              default:
                return const Scaffold(
                  body: Center(
                    child: Text('How?'),
                  ),
                );
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
