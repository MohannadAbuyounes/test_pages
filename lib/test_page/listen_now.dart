import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class ListenNow extends StatelessWidget {
  final String frequency;

  ListenNow({required this.frequency});

  void _openRadioApp() async {
    final String radioAppUrlScheme = 'radioapp://frequency=$frequency';

    if (await canLaunch(radioAppUrlScheme)) {
      final PermissionStatus status = await Permission.microphone.request();
      if (status.isGranted) {
        await launch(radioAppUrlScheme);
      } else {
        print('Permission denied to access the microphone.');
      }
    } else {
      print('Could not launch the radio application.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text('Listen Now'),
      ),
      body: Center(
        child: MaterialButton(
          color: Colors.blueGrey,
          onPressed: _openRadioApp,
          child: Text(
            'Open Radio App with $frequency',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
