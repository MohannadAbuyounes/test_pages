import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_note/helper.dart';

class ListenNow extends StatelessWidget {
  final String frequency;

  ListenNow({required this.frequency});

  Future<void> openRadioAppWithFrequency(String frequency) async {
    final radioAppUrl = 'radioapp://tune?frequency=$frequency';
    if (await canLaunch(radioAppUrl)) {
      await launch(radioAppUrl);
    } else {
      HelperFunctions.showToastMessage(
          message: throw 'Could not launch the radio application');

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
          onPressed: () {
            openRadioAppWithFrequency('98.5%20FM');
          },
          child: Text(
            'Open Radio App with $frequency',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
