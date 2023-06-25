import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../helper.dart';

class VideoNow extends StatefulWidget {
  final List<CameraDescription> cameras;

  const VideoNow({Key? key, required this.cameras}) : super(key: key);

  @override
  _VideoNowState createState() => _VideoNowState();
}

class _VideoNowState extends State<VideoNow> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String _videoPath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final firstCamera = widget.cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();

    await _initializeControllerFuture;

    setState(() {}); // Trigger a rebuild once the controller is initialized
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startRecording() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    try {
      await _initializeControllerFuture;

      final Directory appDir = await getTemporaryDirectory();
      final String currentTime =
          DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'video_$currentTime.mp4';
      final String videoPath = join(appDir.path, fileName);

      setState(() {
        _videoPath = videoPath;
      });

      await _controller.startVideoRecording();
      HelperFunctions.showToastMessage(
          message: 'Start Video\nVideo saved: $currentTime',
          backgroundColor: Colors.blueGrey);
    } catch (e) {
      log('kkkkkk$e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return;
    }

    try {
      await _controller.stopVideoRecording();
      final bool? isSaved = await GallerySaver.saveVideo(_videoPath);
      if (isSaved!) {
        log('Video saved: $_videoPath');
      } else {
        log('Error saving video to the gallery');
      }
    } catch (e) {
      log('Error stopping video recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text('Video Recorder'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CameraPreview(_controller),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  onPressed: _startRecording,
                  child: const Icon(
                    Icons.video_call,
                  ),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  onPressed: _stopRecording,
                  child: const Icon(Icons.stop),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
