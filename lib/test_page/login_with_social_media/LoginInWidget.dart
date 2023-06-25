import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../provider/google_sign_in_provider.dart';
import '../listen_now.dart';
import '../upload_image.dart';
import '../video_now.dart';
import '../voice_recorder.dart';
import 'login_with_social_media.dart';

class LoginInWidget extends StatelessWidget {
  const LoginInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is null, for example, show a loading spinner or redirect to login page
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text('Test page'),
        actions: [
          TextButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              user.photoURL ??
                  '', // Use a default value or handle the case when photoURL is null
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 10),
          Text(
              ' Email:${user.email ?? ''}'), // Use a default value or handle the case when email is null
          const SizedBox(height: 20),
          Text(
              "Name: ${user.displayName ?? ''}"), // Use a default value or handle the case when displayName is null
          const SizedBox(height: 100),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  color: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadImage()),
                    );
                  },
                  child: const Text(
                    'Upload image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                MaterialButton(
                  color: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VoiceRecorder()),
                    );
                  },
                  child: const Text(
                    'Recorder now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                MaterialButton(
                  color: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder<PermissionStatus>(
                          future: Permission.microphone.request(),
                          builder: (BuildContext context,
                              AsyncSnapshot<PermissionStatus> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.data ==
                                PermissionStatus.denied) {
                              return const Text(
                                  'Permission denied to access the microphone.');
                            } else {
                              return ListenNow(frequency: '98.5 FM');
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Listen now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                FutureBuilder<List<CameraDescription>>(
                  future: availableCameras(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Center(
                        child: MaterialButton(
                          color: Colors.blueGrey,
                          onPressed: () {
                            try {
                              final cameras = snapshot.data;
                              if (cameras != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VideoNow(cameras: cameras)),
                                );
                              } else {
                                // Handle the case when cameras is null, for example, show an error message
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'Failed to retrieve available cameras.'),
                                  ),
                                );
                              }
                            } catch (e) {
                              log('message&::::$e');
                            }
                          },
                          child: const Text(
                            'Go to CAM',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
