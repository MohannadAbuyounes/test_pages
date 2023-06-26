import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voice_note/helper.dart';

class ListenNow extends StatelessWidget {
  final String frequency;

  const ListenNow({required this.frequency});

  Future<void> openRadioAppWithFrequency(String frequency) async {
    try {
      final radioAppUrl =
          '/data/user/0/com.example.WOW_FM://tune?frequency=$frequency';

      Uri uri = Uri.parse(radioAppUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        'Could not launch the radio application';
      }
    } catch (e) {
      log('aaaaa:$e');
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
            openRadioAppWithFrequency('98.5');
          },
          child: Text(
            'Open Radio App with $frequency',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
