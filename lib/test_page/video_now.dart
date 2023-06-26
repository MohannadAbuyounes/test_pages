import 'dart:async';
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
  late int _currentCameraIndex = 0;
  double _progressValue = 0.0;
  double _recordedTime = 0;
  bool _isRecording = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final firstCamera = widget.cameras[_currentCameraIndex];

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
    if (!_controller.value.isInitialized || _isRecording) {
      return;
    }

    try {
      await _initializeControllerFuture;

      final Directory appDir = await getTemporaryDirectory();
      final String currentTime =
          DateTime.now().microsecondsSinceEpoch.toString();
      final String fileName = 'video_$currentTime.mp4';
      final String videoPath = join(appDir.path, fileName);

      setState(() {
        _videoPath = videoPath;
        _progressValue = 0.0;
        _recordedTime = 0;
        _isRecording = true;
      });

      await _controller.startVideoRecording();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _recordedTime++;
          _progressValue = _recordedTime /
              10; // Adjust the value as per your desired duration
        });
      });
      HelperFunctions.showToastMessage(
          message: 'Start Video\nVideo saved: $currentTime',
          backgroundColor: Colors.blueGrey);
    } catch (e) {
      log('Error starting video recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_controller.value.isRecordingVideo || !_isRecording) {
      return;
    }

    try {
      _timer.cancel();
      await _controller.stopVideoRecording();
      final bool? isSaved = await GallerySaver.saveVideo(_videoPath);
      if (isSaved!) {
        log('Video saved: $_videoPath');
      } else {
        log('Error saving video to the gallery');
      }
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      log('Error stopping video recording: $e');
    }
  }

  Future<void> _switchRecording() async {
    if (_controller.value.isRecordingVideo || _isRecording) {
      return; // Prevent camera switch during recording
    }

    setState(() {
      _currentCameraIndex = (_currentCameraIndex + 1) % widget.cameras.length;
    });

    await _controller.dispose();
    _initializeCamera();
  }

  String _formatTime(double time) {
    final int minutes = (time / 60).floor();
    final int seconds = (time % 60).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
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
        children: [
          CameraPreview(
            _controller,
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/office.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child:
                Container(), // Add an empty container to allow touch events on the camera preview
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_formatTime(_recordedTime)),
                const SizedBox(height: 10),
                Row(
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
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      backgroundColor: Colors.blueGrey,
                      onPressed: _switchRecording,
                      child: const Icon(Icons.cameraswitch_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
  